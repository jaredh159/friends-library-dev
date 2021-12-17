import Fluent
import Vapor

struct User: Authenticatable {
  var token: Token

  func hasScope(_ scope: Scope) -> Bool {
    switch token.scopes {
      case .notLoaded:
        // @TODO, maybe throw? or log?
        return false
      case let .loaded(scopes):
        return scopes.contains { $0.scope == scope }
    }
  }
}

struct UserAuthenticator: BearerAuthenticator {
  func authenticate(
    bearer: BearerAuthorization,
    for request: Request
  ) -> EventLoopFuture<Void> {
    guard let tokenValue = UUID(uuidString: bearer.token) else {
      return request.eventLoop.makeSucceededVoidFuture()
    }

    do {
      return try Current.db.getTokenByValue(.init(rawValue: tokenValue))
        .map { request.auth.login(User(token: $0)) }
    } catch {
      return request.eventLoop.makeSucceededVoidFuture()
    }
  }
}

extension Request {
  func requirePermission(to scope: Scope) throws {
    guard Current.auth.userCan(self.auth.get(User.self), scope) else {
      throw Abort(.unauthorized)
    }
  }
}
