import Foundation
import PairQL

struct AudiobooksPage: Pair {
  static var auth: Scope = .queryEntities

  typealias Input = Lang

  struct AudiobookOutput: PairOutput {
    var slug: String
    var title: String
    var htmlShortTitle: String
    var editionType: EditionType
    var isbn: ISBN
    var customCss: String?
    var customHtml: String?
    var isCompilation: Bool
    var authorName: String
    var authorSlug: String
    var authorGender: Friend.Gender
    var duration: String
    var shortDescription: String
    var createdAt: Date
  }

  typealias Output = [AudiobookOutput]
}

extension AudiobooksPage: Resolver {
  static func resolve(with input: Input, in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)
    let audiobooks = try await Audio.query().all()
    return try audiobooks.compactMap { audiobook in
      let edition = audiobook.edition.require()
      let document = edition.document.require()
      let friend = document.friend.require()
      let parts = audiobook.parts.require()
      guard friend.lang == input,
            !edition.isDraft,
            !parts.isEmpty,
            edition.impression.require() != nil else {
        return nil
      }
      return .init(
        slug: document.slug,
        title: document.title,
        htmlShortTitle: document.htmlShortTitle,
        editionType: edition.type,
        isbn: try expect(edition.isbn.require()).code,
        isCompilation: friend.isCompilations,
        authorName: friend.name,
        authorSlug: friend.slug,
        authorGender: friend.gender,
        duration: audiobook.humanDurationClock,
        shortDescription: document.partialDescription,
        createdAt: audiobook.createdAt
      )
    }
  }
}
