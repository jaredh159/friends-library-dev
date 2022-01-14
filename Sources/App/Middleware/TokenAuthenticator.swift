import Fluent
import Vapor

struct User: Authenticatable {
  var token: Token

  func hasScope(_ scope: Scope) -> Bool {
    switch token.scopes {
      case .notLoaded:
        Current.logger.error("Non-loaded token scopes in User authentication")
        return false
      case .loaded(let scopes):
        return scopes.contains { $0.scope == scope || $0.scope == .all }
    }
  }
}

struct UserAuthenticator: AsyncBearerAuthenticator {

  func authenticate(bearer: BearerAuthorization, for request: Request) async throws {
    guard let tokenValue = UUID(uuidString: bearer.token) else {
      return
    }
    do {
      let token = try await Current.db.getTokens(Token[.value] == .uuid(tokenValue))
        .firstOrThrowNotFound()
      request.auth.login(User(token: token))
    } catch {
      return
    }
  }
}

extension Request {
  func requirePermission(to scope: Scope) throws {
    guard Current.auth.userCan(auth.get(User.self), scope) else {
      throw Abort(.unauthorized)
    }
  }
}
