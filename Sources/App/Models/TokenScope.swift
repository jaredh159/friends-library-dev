import Fluent
import Vapor

enum Scope: String, Codable, CaseIterable, Equatable {
  case queryDownloads
  case mutateDownloads
  case queryOrders
  case mutateOrders
}

final class TokenScope: Model, Content {
  static let schema = "token_scopes"

  @ID(key: .id)
  var id: UUID?

  @Enum(key: "scope")
  var scope: Scope

  @Parent(key: "token_id")
  var token: Token

  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?

  init() {}

  init(id: UUID? = nil, tokenId: UUID? = nil, scope: Scope, createdAt: Date? = nil) {
    self.id = id
    self.scope = scope
    self.createdAt = createdAt ?? Date()
    if let tokenId = tokenId {
      self.$token.id = tokenId
    }
  }
}
