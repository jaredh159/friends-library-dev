// auto-generated, do not edit
import DuetSQL
import Tagged

extension Document: ApiModel {
  typealias Id = Tagged<Document, UUID>
}

extension Document: Model {
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
        return constraint.isSatisfiedBy(.id(self))
      case .friendId:
        return constraint.isSatisfiedBy(.uuid(friendId))
      case .altLanguageId:
        return constraint.isSatisfiedBy(.uuid(altLanguageId))
      case .title:
        return constraint.isSatisfiedBy(.string(title))
      case .slug:
        return constraint.isSatisfiedBy(.string(slug))
      case .filename:
        return constraint.isSatisfiedBy(.string(filename))
      case .published:
        return constraint.isSatisfiedBy(.int(published))
      case .originalTitle:
        return constraint.isSatisfiedBy(.string(originalTitle))
      case .incomplete:
        return constraint.isSatisfiedBy(.bool(incomplete))
      case .description:
        return constraint.isSatisfiedBy(.string(description))
      case .partialDescription:
        return constraint.isSatisfiedBy(.string(partialDescription))
      case .featuredDescription:
        return constraint.isSatisfiedBy(.string(featuredDescription))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
      case .updatedAt:
        return constraint.isSatisfiedBy(.date(updatedAt))
      case .deletedAt:
        return constraint.isSatisfiedBy(.date(deletedAt))
    }
  }
}

extension Document: Auditable {}
extension Document: Touchable {}
