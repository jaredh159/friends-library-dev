// auto-generated, do not edit
import Foundation
import Tagged

extension RelatedDocument: AppModel {
  typealias Id = Tagged<RelatedDocument, UUID>
}

extension RelatedDocument: DuetModel {
  static let tableName = M22.tableName
}

extension RelatedDocument {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case description
    case documentId
    case parentDocumentId
    case createdAt
    case updatedAt
  }
}

extension RelatedDocument: Auditable {}
extension RelatedDocument: Touchable {}
