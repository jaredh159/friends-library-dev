import DuetSQL
import PairQL

struct GettingStartedBooks: Pair {
  static var auth: Scope = .queryEntities

  struct Input: PairInput {
    let lang: Lang
    let slugs: [Slugs]

    struct Slugs: PairNestable {
      let friendSlug: String
      let documentSlug: String
    }
  }

  struct DocumentOutput: PairOutput {
    let title: String
    let slug: String
    let editionType: EditionType
    let isbn: ISBN
    let customCss: String?
    let customHtml: String?
    let isCompilation: Bool
    let authorName: String
    let authorSlug: String
    let authorGender: Friend.Gender
    let htmlShortTitle: String
    let hasAudio: Bool
  }

  typealias Output = [DocumentOutput]
}

extension GettingStartedBooks: Resolver {
  static func resolve(with input: Input, in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)
    var output: Output = []

    let documents = try await Document.query()
      .where(.slug |=| input.slugs.map { .string($0.documentSlug) })
      .all()

    for slug in input.slugs {
      let document = try expect(documents.filter { document in
        guard document.slug == slug.documentSlug else { return false }
        let friend = document.friend.require()
        return friend.slug == slug.friendSlug && friend.lang == input.lang
      }.first)

      let friend = try expect(document.friend.require())
      let edition = try expect(document.primaryEdition)
      output.append(.init(
        title: document.title,
        slug: document.slug,
        editionType: edition.type,
        isbn: try expect(edition.isbn.require()).code,
        customCss: nil,
        customHtml: nil,
        isCompilation: friend.isCompilations,
        authorName: friend.name,
        authorSlug: friend.slug,
        authorGender: friend.gender,
        htmlShortTitle: document.htmlShortTitle,
        hasAudio: edition.audio.require() != nil
      ))
    }

    return output
  }
}
