import Foundation
import Tagged

final class Token: Codable {
  var id: Id
  var value: Value
  var description: String
  var createdAt = Current.date()

  var scopes = Children<TokenScope>.notLoaded

  init(id: Id = .init(), value: Value = .init(), description: String) {
    self.id = id
    self.value = value
    self.description = description
  }
}

/// extensions

extension Token {
  typealias Value = Tagged<(Token, value: ()), UUID>
}
