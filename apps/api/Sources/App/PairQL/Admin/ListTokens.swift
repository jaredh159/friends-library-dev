import Foundation
import PairQL
import TaggedMoney

struct ListTokens: Pair {
  static var auth: Scope = .queryTokens

  struct TokenOutput: PairOutput {
    struct ScopeOutput: PairNestable {
      var id: TokenScope.Id
      var type: Scope
    }

    var id: Token.Id
    var description: String
    var uses: Int?
    var scopes: [ScopeOutput]
    var createdAt: Date
  }

  typealias Output = [TokenOutput]
}

extension ListTokens: NoInputResolver {
  static func resolve(in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)
    let tokens = try await Token.query().all()
    return try await tokens.concurrentMap { token in
      let scopes = try await token.scopes()
      return .init(
        id: token.id,
        description: token.description,
        uses: token.uses,
        scopes: scopes.map { .init(id: $0.id, type: $0.scope) },
        createdAt: token.createdAt
      )
    }
  }
}
