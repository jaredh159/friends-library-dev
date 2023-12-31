import NonEmpty
import PairQL

struct DpcEditions: Pair {
  static var auth: Scope = .queryEntities

  struct EditionOutput: PairOutput {
    let id: Edition.Id
    let type: EditionType
    let editor: String?
    let directoryPath: String
    let paperbackSplits: [Int]?
    let isbn: ISBN?
    let document: DocumentOutput
    let friend: FriendOutput

    struct DocumentOutput: PairNestable {
      let title: String
      let originalTitle: String?
      let description: String
      let slug: String
      let published: Int?
    }

    struct FriendOutput: PairNestable {
      let isCompilations: Bool
      let name: String
      let alphabeticalName: String
      let slug: String
      let lang: Lang
    }
  }

  typealias Output = [EditionOutput]
}

extension DpcEditions: NoInputResolver {
  static func resolve(in context: AuthedContext) async throws -> Output {
    let editions = try await Edition.query().all()
    return try await editions.concurrentMap { edition in
      async let isbn = edition.isbn()
      async let document = edition.document()
      let friend = try await document.friend()
      return .init(
        id: edition.id,
        type: edition.type,
        editor: edition.editor,
        directoryPath: edition.directoryPath,
        paperbackSplits: edition.paperbackSplits.map { Array($0) },
        isbn: try await isbn?.code,
        document: .init(
          title: try await document.title,
          originalTitle: try await document.originalTitle,
          description: try await document.description,
          slug: try await document.slug,
          published: try await document.published
        ),
        friend: .init(
          isCompilations: friend.isCompilations,
          name: friend.name,
          alphabeticalName: friend.alphabeticalName,
          slug: friend.slug,
          lang: friend.lang
        )
      )
    }
  }
}
