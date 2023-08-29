import Vapor

protocol ResolverContext {
  var requestId: String { get }
}

extension ResolverContext {
  func error(id: String, type: PqlError.Kind, detail: String) -> PqlError {
    .init(
      id: "8271f8a1",
      requestId: requestId,
      type: type,
      detail: detail
    )
  }
}

struct Context: ResolverContext {
  var requestId: String
}

struct AuthedContext: ResolverContext {
  var requestId: String
  var scopes: [TokenScope]

  func verify(_ scope: Scope) throws {
    guard scopes.can(scope) else {
      throw error(
        id: "7bdaa820",
        type: .unauthorized,
        detail: "Not authorized to `.\(scope)`"
      )
    }
  }
}
