import DuetSQL
import Tagged

final class Token: Codable {
  var id: Id
  var value: Value
  var description: String
  var uses: Int?
  var createdAt = Current.date()

  var scopes = Children<TokenScope>.notLoaded

  var isValid: Bool { true }

  init(id: Id = .init(), value: Value = .init(), description: String, uses: Int? = nil) {
    self.id = id
    self.value = value
    self.description = description
    self.uses = uses
  }
}

/// extensions

extension Token {
  typealias Value = Tagged<(Token, value: ()), UUID>
}

extension Token {
  func scopes() async throws -> [TokenScope] {
    try await scopes.useLoaded(or: {
      try await TokenScope.query()
        .where(.tokenId == id)
        .all()
    })
  }
}
