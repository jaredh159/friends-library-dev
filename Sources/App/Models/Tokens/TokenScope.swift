import Foundation

enum Scope: String, Codable, CaseIterable, Equatable {
  case queryDownloads
  case mutateDownloads
  case queryOrders
  case mutateOrders
  case mutateArtifactProductionVersions
}

final class TokenScope: Codable {
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

// extensions

extension Scope: PostgresEnum {
  var dataType: String { TokenScope.M5.dbEnumName }
}
