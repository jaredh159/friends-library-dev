import DuetSQL
import Foundation
import NonEmpty
import PairQL
import Vapor

struct AudioQualities<T: PairNestable>: PairNestable {
  let lq: T
  let hq: T
}

struct DocumentPage: Pair {
  static var auth: Scope = .queryEntities

  struct Input: PairInput {
    var lang: Lang
    var friendSlug: String
    var documentSlug: String
  }

  struct DocumentOutput: PairNestable {
    var friendName: String
    var friendSlug: String
    var friendGender: Friend.Gender
    var title: String
    var htmlTitle: String
    var htmlShortTitle: String
    var originalTitle: String?
    var isComplete: Bool
    var priceInCents: Int
    var description: String
    var numDownloads: Int
    var isCompilation: Bool
    var ogImageUrl: String
    var editions: [EditionOutput]
    var alternateLanguageDoc: AlternateLanguageDoc?
    var primaryEdition: PrimaryEdition
    var customCss: String?
    var customCssUrl: String?

    struct AlternateLanguageDoc: PairNestable {
      var friendSlug: String
      var slug: String
    }
  }

  struct PrimaryEdition: PairNestable {
    var editionType: EditionType
    var printSize: PrintSize
    var paperbackVolumes: NonEmpty<[Int]>
    var isbn: ISBN
    var numChapters: Int
    var audiobook: Audiobook?

    struct Audiobook: PairNestable {
      var isIncomplete: Bool
      var numAudioParts: Int
      var m4bFilesize: AudioQualities<Bytes>
      var mp3ZipFilesize: AudioQualities<Bytes>
      var m4bLoggedDownloadUrl: AudioQualities<String>
      var mp3ZipLoggedDownloadUrl: AudioQualities<String>
      var podcastLoggedDownloadUrl: AudioQualities<String>
      var embedId: AudioQualities<Int64>
    }
  }

  struct OtherBookByFriend: PairNestable {
    var title: String
    var editionType: EditionType
    var description: String
    var paperbackVolumes: NonEmpty<[Int]>
    var isbn: ISBN
    var audioDuration: String?
    var htmlShortTitle: String
    var documentSlug: String
    var createdAt: Date
  }

  struct EditionOutput: PairNestable {
    var id: Edition.Id
    var type: EditionType
    var isbn: ISBN
    var printSize: PrintSize
    var numPages: NonEmpty<[Int]>
    var loggedDownloadUrls: LoggedDownloadUrls

    struct LoggedDownloadUrls: PairNestable {
      var epub: String
      var mobi: String
      var pdf: String
      var speech: String
    }
  }

  struct Output: PairOutput {
    var document: DocumentOutput
    var otherBooksByFriend: [OtherBookByFriend]
    var numTotalBooks: Int
  }
}

extension DocumentPage: Resolver {
  static func resolve(with input: Input, in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)
    async let allDocuments = Document.query().all()
    async let matchingDocuments = Document.query()
      .where(.slug == input.documentSlug)
      .all()

    let numTotalBooks = try await allDocuments
      .filter(\.hasNonDraftEdition)
      .filter { $0.lang == input.lang }
      .count

    let document = try await matchingDocuments
      .first { $0.lang == input.lang && $0.friend.require().slug == input.friendSlug }

    guard let document else {
      throw Abort(.notFound)
    }

    return try .init(
      document,
      downloads: [document.urlPath: try await document.numDownloads()],
      numTotalBooks: numTotalBooks,
      in: context
    )
  }
}

extension DocumentPage.Output {
  init(
    _ document: Document,
    downloads: [String: Int],
    numTotalBooks: Int,
    in context: AuthedContext
  ) throws {
    let friend = document.friend.require()
    let editions = document.editions.require()
    let primaryEdition = try expect(document.primaryEdition)
    let primaryEditionImpression = try expect(primaryEdition.impression.require())
    let isbn = try expect(primaryEdition.isbn.require())

    var audiobook: DocumentPage.PrimaryEdition.Audiobook?
    if let audio = primaryEdition.audio.require() {
      let audioParts = audio.parts.require()
      guard let firstAudioPart = audioParts.first else {
        throw context.error(id: "08cfb2ed", type: .serverError)
      }
      let embedId: AudioQualities<Int64>
      if audioParts.count == 1 {
        embedId = .init(
          lq: firstAudioPart.externalIdLq.rawValue,
          hq: firstAudioPart.externalIdHq.rawValue
        )
      } else if let playlistIdHq = audio.externalPlaylistIdHq,
                let playlistIdLq = audio.externalPlaylistIdLq {
        embedId = .init(
          lq: playlistIdLq.rawValue,
          hq: playlistIdHq.rawValue
        )
      } else {
        throw context.error(id: "0516b86f", type: .serverError)
      }
      audiobook = .init(
        isIncomplete: audio.isIncomplete,
        numAudioParts: audioParts.count,
        m4bFilesize: .init(lq: audio.m4bSizeLq, hq: audio.m4bSizeHq),
        mp3ZipFilesize: .init(lq: audio.mp3ZipSizeLq, hq: audio.mp3ZipSizeHq),
        m4bLoggedDownloadUrl: .init(
          lq: audio.files.m4b.lq.logUrl.absoluteString,
          hq: audio.files.m4b.hq.logUrl.absoluteString
        ),
        mp3ZipLoggedDownloadUrl: .init(
          lq: audio.files.mp3s.lq.logUrl.absoluteString,
          hq: audio.files.mp3s.hq.logUrl.absoluteString
        ),
        podcastLoggedDownloadUrl: .init(
          lq: audio.files.podcast.lq.logUrl.absoluteString,
          hq: audio.files.podcast.hq.logUrl.absoluteString
        ),
        embedId: embedId
      )
    }

    self = .init(
      document: .init(
        friendName: friend.name,
        friendSlug: friend.slug,
        friendGender: friend.gender,
        title: document.title,
        htmlTitle: document.htmlTitle,
        htmlShortTitle: document.htmlShortTitle,
        originalTitle: document.originalTitle,
        isComplete: !document.incomplete,
        priceInCents: primaryEditionImpression.paperbackPrice.rawValue,
        description: document.description,
        numDownloads: downloads[document.urlPath] ?? 0,
        isCompilation: friend.isCompilations,
        ogImageUrl: primaryEdition.images.threeD.w700.url.absoluteString,
        editions: try editions.filter { !$0.isDraft }.map { edition in
          let impression = try expect(edition.impression.require())
          return .init(
            id: edition.id,
            type: edition.type,
            isbn: try expect(edition.isbn.require()).code,
            printSize: impression.paperbackSize,
            numPages: impression.paperbackVolumes,
            loggedDownloadUrls: .init(
              epub: impression.files.ebook.epub.logUrl.absoluteString,
              mobi: impression.files.ebook.mobi.logUrl.absoluteString,
              pdf: impression.files.ebook.pdf.logUrl.absoluteString,
              speech: impression.files.ebook.speech.logUrl.absoluteString
            )
          )
        },
        alternateLanguageDoc: document.altLanguageDocument.require().map {
          .init(friendSlug: friend.slug, slug: $0.slug)
        },
        primaryEdition: .init(
          editionType: primaryEdition.type,
          printSize: primaryEditionImpression.paperbackSize,
          paperbackVolumes: primaryEditionImpression.paperbackVolumes,
          isbn: isbn.code,
          numChapters: primaryEdition.chapters.require().count,
          audiobook: audiobook
        )
      ),
      otherBooksByFriend: try friend.documents.require().filter(\.hasNonDraftEdition)
        .filter { $0.slug != document.slug }
        .map { otherDoc in
          let edition = try expect(otherDoc.primaryEdition)
          return .init(
            title: otherDoc.title,
            editionType: edition.type,
            description: otherDoc.partialDescription,
            paperbackVolumes: try expect(edition.impression.require()).paperbackVolumes,
            isbn: try expect(edition.isbn.require()).code,
            audioDuration: (edition.audio.require()).map(\.humanDurationClock),
            htmlShortTitle: otherDoc.htmlShortTitle,
            documentSlug: otherDoc.slug,
            createdAt: otherDoc.createdAt
          )
        },
      numTotalBooks: numTotalBooks
    )
  }
}

func expect<T>(_ value: T?, file: StaticString = #file, line: UInt = #line) throws -> T {
  guard let value else {
    throw PqlError(
      id: "87b64b2a",
      requestId: "(unknown)",
      type: .serverError,
      detail: "unexpected nil for \(T.self) from \(file):\(line)"
    )
  }
  return value
}

extension Document {
  var urlPath: String {
    "\(friend.require().slug)/\(slug)"
  }
}
