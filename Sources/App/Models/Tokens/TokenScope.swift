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

final class TokenScope {
  var id: Id
  var scope: Scope
  var tokenId: Token.Id
  var createdAt = Current.date()

  var token = Parent<Token>.notLoaded

  init(id: Id = .init(), tokenId: Token.Id, scope: Scope) {
    self.id = id
    self.scope = scope
    self.tokenId = tokenId
  }
}

/// extensions

extension TokenScope: AppModel {
  typealias Id = Tagged<TokenScope, UUID>
}

extension TokenScope: DuetModel {
  static let tableName = "token_scopes"
}

extension TokenScope: Codable {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case scope
    case tokenId
    case createdAt
  }
}

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

extension Scope: PostgresEnum {
  var dataType: String { TokenScope.M5.dbEnumName }
}
