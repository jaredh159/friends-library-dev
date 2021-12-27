// auto-generated, do not edit
import Foundation
import Tagged

extension Document: AppModel {
  typealias Id = Tagged<Document, UUID>
}

extension Document: DuetModel {
  static let tableName = M13.tableName
}

extension Document {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case friendId
    case altLanguageId
    case title
    case slug
    case filename
    case published
    case originalTitle
    case incomplete
    case description
    case partialDescription
    case featuredDescription
    case createdAt
    case updatedAt
    case deletedAt
  }
}
