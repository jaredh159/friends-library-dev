import Foundation
import PairQL
import TaggedMoney
import TaggedTime

struct GetFriends: Pair {
  static var auth: Scope = .queryEntities

  struct FriendOutput: PairOutput {
    let id: Friend.Id
    let lang: Lang
    let slug: String
    let gender: Friend.Gender
    let name: String
    let born: Int?
    let died: Int?
    let description: String
    let isCompilations: Bool
    let published: Date?
    let hasNonDraftDocument: Bool
    let primaryResidence: PrimaryResidence?
    let documents: [DocumentOutput]
    let relatedDocuments: [RelatedDocumentOutput]
    let quotes: [QuoteOutput]
    let residences: [Residence]
  }

  struct DocumentOutput: PairNestable {
    let id: Document.Id
    let title: String
    let htmlTitle: String
    let htmlShortTitle: String
    let utf8ShortTitle: String
    let originalTitle: String?
    let slug: String
    let published: Int?
    let incomplete: Bool
    let directoryPath: String
    let description: String
    let partialDescription: String
    let featuredDescription: String?
    let hasNonDraftEdition: Bool
    let tags: [DocumentTag.TagType]
    let altLanguageDocument: AltLanguageDocument?
    let editions: [EditionOutput]
    let primaryEdition: PrimaryEdition?
    let relatedDocuments: [RelatedDocumentOutput]
  }

  struct AltLanguageDocument: PairNestable {
    let slug: String
    let htmlShortTitle: String
    let hasNonDraftEdition: Bool
    let friendSlug: String
  }

  struct EditionOutput: PairNestable {
    let id: Edition.Id
    let type: EditionType
    let isDraft: Bool
    let path: String
    let numChapters: Int
    let isbn: ISBN?
    let podcastImageUrl: String
    let impression: Impression?
    let audio: AudioOutput?
  }

  struct PrimaryEdition: PairNestable {
    let id: Edition.Id
    let type: EditionType
    let ogImageUrl: String
  }

  struct Impression: PairNestable {
    let paperbackPriceInCents: Cents<Int>
    let paperbackSize: PrintSize
    let paperbackVolumes: [Int]
    let ebookPdfLogUrl: String
    let ebookMobiLogUrl: String
    let ebookEpubLogUrl: String
    let ebookSpeechLogUrl: String
    let createdAt: Date
  }

  struct AudioOutput: PairNestable {
    let reader: String
    let isPublished: Bool
    let isIncomplete: Bool
    let externalPlaylistIdHq: Audio.ExternalPlaylistId?
    let externalPlaylistIdLq: Audio.ExternalPlaylistId?
    let m4bSizeHq: Bytes
    let m4bSizeLq: Bytes
    let mp3ZipSizeHq: Bytes
    let mp3ZipSizeLq: Bytes
    let humanDurationClock: String
    let parts: [AudioPartOutput]
    let m4bFileLogUrlHq: String
    let m4bFileLogUrlLq: String
    let mp3ZipFileLogUrlHq: String
    let mp3ZipFileLogUrlLq: String
    let podcastLogUrlHq: String
    let podcastLogUrlLq: String
    let podcastSourcePathHq: String
    let podcastSourcePathLq: String
    let createdAt: Date
  }

  struct AudioPartOutput: PairNestable {
    let title: String
    let isPublished: Bool
    let order: Int
    let chapters: [Int]
    let duration: Seconds<Double>
    let externalIdHq: AudioPart.ExternalId
    let externalIdLq: AudioPart.ExternalId
    let mp3SizeHq: Bytes
    let mp3SizeLq: Bytes
    let mp3FileLogUrlHq: String
    let mp3FileLogUrlLq: String
  }

  struct Residence: PairNestable {
    let city: String
    let region: String
    let durations: [Duration]
  }

  struct Duration: PairNestable {
    let start: Int
    let end: Int
  }

  struct RelatedDocumentOutput: PairNestable {
    let description: String
    let documentId: Document.Id
    let documentHtmlShortTitle: String
    let documentDescription: String
  }

  struct QuoteOutput: PairNestable {
    let order: Int
    let source: String
    let text: String
  }

  struct PrimaryResidence: PairNestable {
    let region: String
    let city: String
  }

  typealias Output = [FriendOutput]
}

extension GetFriends: NoInputResolver {
  static func resolve(in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)
    let friends = try await Friend.query().all()
    return try await friends.concurrentMap { friend in
      let residences = try await friend.residences()
      let documents = try await friend.documents()
      let quotes = try await friend.quotes()
      return .init(
        id: friend.id,
        lang: friend.lang,
        slug: friend.slug,
        gender: friend.gender,
        name: friend.name,
        born: friend.born,
        died: friend.died,
        description: friend.description,
        isCompilations: friend.isCompilations,
        published: friend.published,
        hasNonDraftDocument: friend.hasNonDraftDocument,
        primaryResidence: friend.primaryResidence.map { .init(region: $0.region, city: $0.city) },
        documents: try await documents.concurrentMap { document in
          let tags = try await document.tags()
          let editions = try await document.editions()
          let altLanguageDocument = try await document.altLanguageDocument()
          let relatedDocuments = try await document.relatedDocuments()
          return .init(
            id: document.id,
            title: document.title,
            htmlTitle: document.htmlTitle,
            htmlShortTitle: document.htmlShortTitle,
            utf8ShortTitle: document.utf8ShortTitle,
            originalTitle: document.originalTitle,
            slug: document.slug,
            published: document.published,
            incomplete: document.incomplete,
            directoryPath: document.directoryPath,
            description: document.description,
            partialDescription: document.partialDescription,
            featuredDescription: document.featuredDescription,
            hasNonDraftEdition: document.hasNonDraftEdition,
            tags: tags.map(\.type),
            altLanguageDocument: altLanguageDocument.map { .init(
              slug: $0.slug,
              htmlShortTitle: $0.htmlShortTitle,
              hasNonDraftEdition: $0.hasNonDraftEdition,
              friendSlug: friend.slug
            ) },
            editions: try await editions.concurrentMap { edition in
              let chapters = try await edition.chapters()
              let isbn = try await edition.isbn()
              let impression = try await edition.impression()
              var audioOutput: AudioOutput?
              if let audio = try await edition.audio() {
                let parts = try await audio.parts()
                audioOutput = .init(
                  reader: audio.reader,
                  isPublished: audio.isPublished,
                  isIncomplete: audio.isIncomplete,
                  externalPlaylistIdHq: audio.externalPlaylistIdHq,
                  externalPlaylistIdLq: audio.externalPlaylistIdLq,
                  m4bSizeHq: audio.m4bSizeHq,
                  m4bSizeLq: audio.m4bSizeLq,
                  mp3ZipSizeHq: audio.mp3ZipSizeHq,
                  mp3ZipSizeLq: audio.mp3ZipSizeLq,
                  humanDurationClock: audio.humanDurationClock,
                  parts: parts.map { part in .init(
                    title: part.title,
                    isPublished: part.isPublished,
                    order: part.order,
                    chapters: Array(part.chapters),
                    duration: part.duration,
                    externalIdHq: part.externalIdHq,
                    externalIdLq: part.externalIdLq,
                    mp3SizeHq: part.mp3SizeHq,
                    mp3SizeLq: part.mp3SizeLq,
                    mp3FileLogUrlHq: part.mp3File.hq.logUrl.absoluteString,
                    mp3FileLogUrlLq: part.mp3File.lq.logUrl.absoluteString
                  ) },
                  m4bFileLogUrlHq: audio.files.m4b.hq.logUrl.absoluteString,
                  m4bFileLogUrlLq: audio.files.m4b.lq.logUrl.absoluteString,
                  mp3ZipFileLogUrlHq: audio.files.mp3s.hq.logUrl.absoluteString,
                  mp3ZipFileLogUrlLq: audio.files.mp3s.lq.logUrl.absoluteString,
                  podcastLogUrlHq: audio.files.podcast.hq.logUrl.absoluteString,
                  podcastLogUrlLq: audio.files.podcast.lq.logUrl.absoluteString,
                  podcastSourcePathHq: audio.files.podcast.hq.sourcePath,
                  podcastSourcePathLq: audio.files.podcast.lq.sourcePath,
                  createdAt: audio.createdAt
                )
              }
              return .init(
                id: edition.id,
                type: edition.type,
                isDraft: edition.isDraft,
                path: edition.directoryPath,
                numChapters: chapters.count,
                isbn: isbn?.code,
                podcastImageUrl: edition.images.square.w1400.url.absoluteString,
                impression: impression.map { impression in .init(
                  paperbackPriceInCents: impression.paperbackPrice,
                  paperbackSize: impression.paperbackSize,
                  paperbackVolumes: Array(impression.paperbackVolumes),
                  ebookPdfLogUrl: impression.files.ebook.pdf.logUrl.absoluteString,
                  ebookMobiLogUrl: impression.files.ebook.mobi.logUrl.absoluteString,
                  ebookEpubLogUrl: impression.files.ebook.epub.logUrl.absoluteString,
                  ebookSpeechLogUrl: impression.files.ebook.speech.logUrl.absoluteString,
                  createdAt: impression.createdAt
                ) },
                audio: audioOutput
              )
            },
            primaryEdition: document.primaryEdition.map { .init(
              id: $0.id,
              type: $0.type,
              ogImageUrl: $0.images.threeD.w700.url.absoluteString
            ) },
            relatedDocuments: try await relatedDocuments.concurrentMap { related in
              let document = try await Document.find(related.documentId)
              return .init(
                description: related.description,
                documentId: document.id,
                documentHtmlShortTitle: document.htmlShortTitle,
                documentDescription: document.description
              )
            }
          )
        },
        relatedDocuments: try await friend.relatedDocuments.concurrentMap { related in
          let document = try await Document.find(related.documentId)
          return .init(
            description: related.description,
            documentId: document.id,
            documentHtmlShortTitle: document.htmlShortTitle,
            documentDescription: document.description
          )
        },
        quotes: quotes.map { .init(order: $0.order, source: $0.source, text: $0.text) },
        residences: try await residences.concurrentMap { residence in
          let durations = try await residence.durations()
          return .init(
            city: residence.city,
            region: residence.region,
            durations: durations.map { .init(start: $0.start, end: $0.end) }
          )
        }
      )
    }
  }
}
