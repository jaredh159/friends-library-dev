// auto-generated, do not edit
import DuetSQL
import Tagged

extension Friend: ApiModel {
  typealias Id = Tagged<Friend, UUID>
}

extension Friend: Model {
  static let tableName = M11.tableName

  func postgresData(for column: ColumnName) -> Postgres.Data {
    switch column {
      case .id:
        return .id(self)
      case .lang:
        return .enum(lang)
      case .name:
        return .string(name)
      case .slug:
        return .string(slug)
      case .gender:
        return .enum(gender)
      case .description:
        return .string(description)
      case .born:
        return .int(born)
      case .died:
        return .int(died)
      case .published:
        return .date(published)
      case .createdAt:
        return .date(createdAt)
      case .updatedAt:
        return .date(updatedAt)
      case .deletedAt:
        return .date(deletedAt)
    }
  }
}

extension Friend {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case lang
    case name
    case slug
    case gender
    case description
    case born
    case died
    case published
    case createdAt
    case updatedAt
    case deletedAt
  }
}

extension Friend {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .lang: .enum(lang),
      .name: .string(name),
      .slug: .string(slug),
      .gender: .enum(gender),
      .description: .string(description),
      .born: .int(born),
      .died: .int(died),
      .published: .date(published),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }
}
