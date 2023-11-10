import NonEmpty
import PairQL

struct CoverWebAppFriends: Pair {
  static var auth: Scope = .queryEntities

  struct FriendOuput: PairOutput {
    struct DocumentOutput: PairNestable {
      struct EditionOutput: PairNestable {
        let id: Edition.Id
        let path: String
        let type: EditionType
        let pages: [Int]?
        let size: PrintSize?
        let isbn: ISBN?
      }

      let lang: Lang
      let title: String
      let isCompilation: Bool
      let directoryPath: String
      let description: String
      let editions: [EditionOutput]
    }

    let name: String
    let alphabeticalName: String
    let description: String
    let documents: [DocumentOutput]
  }

  typealias Output = [FriendOuput]
}

extension CoverWebAppFriends: NoInputResolver {
  static func resolve(in context: AuthedContext) async throws -> Output {
    let friends = try await Friend.query().all()
    return try await friends.concurrentMap { friend in
      .init(
        name: friend.name,
        alphabeticalName: friend.alphabeticalName,
        description: friend.description,
        documents: try await (try await friend.documents()).concurrentMap { doc in
          .init(
            lang: friend.lang,
            title: doc.title,
            isCompilation: friend.isCompilations,
            directoryPath: doc.directoryPath,
            description: doc.description,
            editions: try await (try await doc.editions()).concurrentMap { edition in
              let isbn = try await edition.isbn()
              let impression = try await edition.impression()
              return .init(
                id: edition.id,
                path: edition.directoryPath,
                type: edition.type,
                pages: impression.map { Array($0.paperbackVolumes) },
                size: impression?.paperbackSize,
                isbn: isbn?.code
              )
            }
          )
        }
      )
    }
  }
}
