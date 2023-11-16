import DuetSQL
import Foundation
import PairQL

struct PublishedDocumentSlugs: Pair {
  static var auth: Scope = .queryEntities
  typealias Input = Lang

  struct Slugs: PairOutput {
    let friendSlug: String
    let documentSlug: String
  }

  typealias Output = [Slugs]
}

extension PublishedDocumentSlugs: Resolver {
  static func resolve(with input: Input, in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)

    let allFriends = try await Friend.query()
      .where(.lang == input)
      .all()

    return try await allFriends.filter(\.hasNonDraftDocument).concurrentMap { friend in
      let documents = try await friend.documents()
      return documents.filter(\.hasNonDraftEdition).map { document in
        Slugs(friendSlug: friend.slug, documentSlug: document.slug)
      }
    }.flatMap { $0 }
  }
}
