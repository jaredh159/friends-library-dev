// auto-generated, do not edit
import DuetSQL
import Tagged

extension FriendQuote: ApiModel {
  typealias Id = Tagged<FriendQuote, UUID>
}

extension FriendQuote: Model {
  static let tableName = M13.tableName

  func postgresData(for column: ColumnName) -> Postgres.Data {
    switch column {
      case .id:
        return .id(self)
      case .friendId:
        return .uuid(friendId)
      case .source:
        return .string(source)
      case .text:
        return .string(text)
      case .order:
        return .int(order)
      case .context:
        return .string(context)
      case .createdAt:
        return .date(createdAt)
      case .updatedAt:
        return .date(updatedAt)
    }
  }
}

extension FriendQuote {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case friendId
    case source
    case text
    case order
    case context
    case createdAt
    case updatedAt
  }
}

extension FriendQuote {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .friendId: .uuid(friendId),
      .source: .string(source),
      .text: .string(text),
      .order: .int(order),
      .context: .string(context),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }
}
