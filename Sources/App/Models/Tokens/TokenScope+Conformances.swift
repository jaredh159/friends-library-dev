// auto-generated, do not edit
import Foundation
import Tagged

extension TokenScope: AppModel {
  typealias Id = Tagged<TokenScope, UUID>
}

extension TokenScope: DuetModel {
  static let tableName = M5.tableName
}

extension TokenScope {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case scope
    case tokenId
    case createdAt
  }
}

extension TokenScope: Auditable {}
