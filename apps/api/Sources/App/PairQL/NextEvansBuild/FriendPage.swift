import DuetSQL
import Foundation
import NonEmpty
import PairQL

struct FriendPage: Pair {
  static var auth: Scope = .queryEntities

  struct Input: PairInput {
    let slug: String
    let lang: Lang
  }

  struct Output: PairOutput {
    let born: Int?
    let died: Int?
    let name: String
    let slug: String
    let description: String
    let gender: Friend.Gender
    let isCompilations: Bool
    let documents: [Document]
    let residences: [Residence]
    let quotes: [Quote]

    struct Document: PairNestable {
      let id: App.Document.Id
      let title: String
      let htmlShortTitle: String
      let shortDescription: String
      let slug: String
      let numDownloads: Int
      let tags: [DocumentTag.TagType]
      let hasAudio: Bool
      let primaryEdition: PrimaryEdition
      let editionTypes: [EditionType]

      struct PrimaryEdition: PairNestable {
        let isbn: ISBN
        let numPages: NonEmpty<[Int]>
        let size: PrintSize
        let type: EditionType
        let customCss: String?
        let customHtml: String?
      }
    }

    struct Quote: PairNestable {
      let text: String
      let source: String
    }

    struct Residence: PairNestable {
      let city: String
      let region: String
      let durations: [Duration]

      struct Duration: PairNestable {
        let start: Int
        let end: Int
      }
    }
  }
}

extension FriendPage: Resolver {
  static func resolve(with input: Input, in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)
    let friend = try await Friend.query()
      .where(.lang == input.lang)
      .where(.slug == input.slug)
      .first()

    let documents = (try await friend.documents()).filter(\.hasNonDraftEdition)
    guard !documents.isEmpty else {
      throw context.error(
        id: "0e8ded83",
        type: .badRequest,
        detail: "friend `\(input.lang)/\(input.slug)` has no published documents"
      )
    }

    let quotes = try await friend.quotes()
    let residences = try await friend.residences()
    guard friend.isCompilations || !residences.isEmpty else {
      throw context.error(
        id: "01c3e020",
        type: .serverError,
        detail: "non-compilations friend `\(input.lang)/\(input.slug)` has no residences"
      )
    }

    return .init(
      born: friend.born,
      died: friend.died,
      name: friend.name,
      slug: friend.slug,
      description: friend.description,
      gender: friend.gender,
      isCompilations: friend.isCompilations,
      documents: try await documents.concurrentMap { document in
        let editions = document.editions.require()
        let primaryEdition = try expect(document.primaryEdition)
        let impression = try expect(primaryEdition.impression.require())
        let isbn = try expect(primaryEdition.isbn.require())
        return .init(
          id: document.id,
          title: document.title,
          htmlShortTitle: document.htmlShortTitle,
          shortDescription: document.partialDescription,
          slug: document.slug,
          numDownloads: try await document.numDownloads(),
          tags: document.tags.require().map(\.type),
          hasAudio: primaryEdition.audio.require() != nil,
          primaryEdition: .init(
            isbn: isbn.code,
            numPages: impression.paperbackVolumes,
            size: impression.paperbackSize,
            type: primaryEdition.type,
            customCss: nil,
            customHtml: nil
          ),
          editionTypes: editions.map(\.type)
        )
      },
      residences: try await residences.concurrentMap { residence in
        let durations = try await residence.durations()
        return .init(
          city: residence.city,
          region: residence.region,
          durations: durations.map { .init(start: $0.start, end: $0.end) }
        )
      },
      quotes: quotes.map { .init(text: $0.text, source: $0.source) }
    )
  }
}
