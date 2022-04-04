// auto-generated, do not edit
import DuetSQL
import Tagged

extension FriendQuote: ApiModel {
  typealias Id = Tagged<FriendQuote, UUID>
}

extension FriendQuote: Model {
  static let tableName = M13.tableName
  static var isSoftDeletable: Bool { false }
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

extension FriendQuote: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<FriendQuote>) -> Bool {
    switch constraint.column {
      case .id:
        return constraint.isSatisfiedBy(.id(self))
      case .friendId:
        return constraint.isSatisfiedBy(.uuid(friendId))
      case .source:
        return constraint.isSatisfiedBy(.string(source))
      case .text:
        return constraint.isSatisfiedBy(.string(text))
      case .order:
        return constraint.isSatisfiedBy(.int(order))
      case .context:
        return constraint.isSatisfiedBy(.string(context))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
      case .updatedAt:
        return constraint.isSatisfiedBy(.date(updatedAt))
    }
  }
}

extension FriendQuote: Auditable {}
extension FriendQuote: Touchable {}
