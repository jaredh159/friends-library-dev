import Fluent
import Vapor

struct User: Authenticatable {
  var token: Token

  func hasScope(_ scope: Scope) -> Bool {
    token.scopes.contains { $0.scope == scope }
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

    return Token.query(on: request.db)
      .with(\.$scopes)
      .filter(\.$value == .init(rawValue: tokenValue))
      .first()
      .flatMap { token in
        if let token = token {
          request.auth.login(User(token: token))
        }
        return request.eventLoop.makeSucceededVoidFuture()
      }
  }
}

extension Request {
  func requirePermission(to scope: Scope) throws {
    guard self.userCan(scope) else {
      throw Abort(.unauthorized)
    }
  }

  func userCan(_ scope: Scope) -> Bool {
    guard let user = self.auth.get(User.self), user.hasScope(scope) else {
      return false
    }
    return true
  }
}
