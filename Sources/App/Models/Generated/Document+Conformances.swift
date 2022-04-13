// auto-generated, do not edit
import DuetSQL
import Tagged

extension Document: ApiModel {
  typealias Id = Tagged<Document, UUID>
}

extension Document: Model {
  static let tableName = M14.tableName

  func postgresData(for column: ColumnName) -> Postgres.Data {
    switch column {
      case .id:
        return .id(self)
      case .friendId:
        return .uuid(friendId)
      case .altLanguageId:
        return .uuid(altLanguageId)
      case .title:
        return .string(title)
      case .slug:
        return .string(slug)
      case .filename:
        return .string(filename)
      case .published:
        return .int(published)
      case .originalTitle:
        return .string(originalTitle)
      case .incomplete:
        return .bool(incomplete)
      case .description:
        return .string(description)
      case .partialDescription:
        return .string(partialDescription)
      case .featuredDescription:
        return .string(featuredDescription)
      case .createdAt:
        return .date(createdAt)
      case .updatedAt:
        return .date(updatedAt)
      case .deletedAt:
        return .date(deletedAt)
    }
  }
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
      .deletedAt: .date(deletedAt),
    ]
  }
}
