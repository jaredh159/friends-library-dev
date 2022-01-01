// auto-generated, do not edit
import Foundation
import Tagged

extension Document: AppModel {
  typealias Id = Tagged<Document, UUID>
}

extension Document: DuetModel {
  static let tableName = M14.tableName
}

extension Document {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.friendId]: .uuid(friendId),
      Self[.altLanguageId]: .uuid(altLanguageId),
      Self[.title]: .string(title),
      Self[.slug]: .string(slug),
      Self[.filename]: .string(filename),
      Self[.published]: .int(published),
      Self[.originalTitle]: .string(originalTitle),
      Self[.incomplete]: .bool(incomplete),
      Self[.description]: .string(description),
      Self[.partialDescription]: .string(partialDescription),
      Self[.featuredDescription]: .string(featuredDescription),
      Self[.createdAt]: .currentTimestamp,
      Self[.updatedAt]: .currentTimestamp,
    ]
  }
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

extension Document: Auditable {}
extension Document: Touchable {}
