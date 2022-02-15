// auto-generated, do not edit
import Foundation
import Tagged

extension Document: ApiModel {
  typealias Id = Tagged<Document, UUID>
  static var preloadedEntityType: PreloadedEntityType? {
    .document(Self.self)
  }
}

extension Document: DuetModel {
  static let tableName = M14.tableName
  static var isSoftDeletable: Bool { true }
}

extension Document {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
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

extension Document {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .friendId: .uuid(friendId),
      .altLanguageId: .uuid(altLanguageId),
      .title: .string(title),
      .slug: .string(slug),
      .filename: .string(filename),
      .published: .int(published),
      .originalTitle: .string(originalTitle),
      .incomplete: .bool(incomplete),
      .description: .string(description),
      .partialDescription: .string(partialDescription),
      .featuredDescription: .string(featuredDescription),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }
}

extension Document: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<Document>) -> Bool {
    switch constraint.column {
      case .id:
        return .id(self) == constraint.value
      case .friendId:
        return .uuid(friendId) == constraint.value
      case .altLanguageId:
        return .uuid(altLanguageId) == constraint.value
      case .title:
        return .string(title) == constraint.value
      case .slug:
        return .string(slug) == constraint.value
      case .filename:
        return .string(filename) == constraint.value
      case .published:
        return .int(published) == constraint.value
      case .originalTitle:
        return .string(originalTitle) == constraint.value
      case .incomplete:
        return .bool(incomplete) == constraint.value
      case .description:
        return .string(description) == constraint.value
      case .partialDescription:
        return .string(partialDescription) == constraint.value
      case .featuredDescription:
        return .string(featuredDescription) == constraint.value
      case .createdAt:
        return .date(createdAt) == constraint.value
      case .updatedAt:
        return .date(updatedAt) == constraint.value
      case .deletedAt:
        return .date(deletedAt) == constraint.value
    }
  }
}

extension Document: Auditable {}
extension Document: Touchable {}
