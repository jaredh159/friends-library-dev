import DuetSQL
import Foundation
import PairQL

struct TotalPublished: Pair {
  static var auth: Scope = .queryEntities

  struct Output: PairOutput {
    var en: Int
    var es: Int
  }
}

extension TotalPublished: NoInputResolver {
  static func resolve(in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)

    let allDocuments = try await Document.query().all()

    return .init(
      en: allDocuments
        .filter(\.hasNonDraftEdition)
        .filter { $0.friend.require().lang == .en }
        .count,
      es: allDocuments
        .filter(\.hasNonDraftEdition)
        .filter { $0.friend.require().lang == .es }
        .count
    )
  }
}
