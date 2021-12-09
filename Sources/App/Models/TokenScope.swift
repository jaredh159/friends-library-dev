import Fluent
import Tagged
import Vapor

enum Scope: String, Codable, CaseIterable, Equatable {
  case queryDownloads
  case mutateDownloads
  case queryOrders
  case mutateOrders
  case mutateArtifactProductionVersions
}

typealias FlpModel = Model & Content & RandomIdGenerating

final class TokenScope: FlpModel {

  static let schema = M5.tableName

  typealias Id = Tagged<TokenScope, UUID>

  @ID(custom: .id, generatedBy: .user)
  var id: Id?

  @Enum(key: M5.scope)
  var scope: Scope

  @Parent(key: M5.tokenId)
  var token: Token

  @Timestamp(key: .createdAt, on: .create)
  var createdAt: Date?

  init() {}

  init(id: Id = .init(), tokenId: Token.Id? = nil, scope: Scope, createdAt: Date? = nil) {
    self.id = id
    self.scope = scope
    self.createdAt = createdAt ?? Date()
    if let tokenId = tokenId {
      self.$token.id = tokenId
    }
  }
}

protocol EmptyInitializing {
  init()
}

protocol RandomIdGenerating {
  associatedtype IdType
  var id: IdType? { get }
  static func randomId() -> IdType
}

extension RandomIdGenerating where IdType: EmptyInitializing {
  static func randomId() -> IdType {
    IdType.init()
  }
}

extension Tagged where RawValue == UUID {
  init() {
    self = .init(rawValue: UUID())
  }
}

extension Tagged: EmptyInitializing where RawValue == UUID {}

let foo = Tagged<(lol: (), rofl: ()), UUID>.init()

extension TokenScope {
  enum M5 {
    static let tableName = "token_scopes"
    static let dbEnumName = "scopes"
    static let scope = FieldKey("scope")
    static let tokenId = FieldKey("token_id")
    enum Scope {
      static let queryDownloads = "queryDownloads"
      static let mutateDownloads = "mutateDownloads"
      static let queryOrders = "queryOrders"
      static let mutateOrders = "mutateOrders"
    }
  }

  enum M9 {
    enum Scope {
      static let mutateArtifactProductionVersions = "mutateArtifactProductionVersions"
    }
  }
}
