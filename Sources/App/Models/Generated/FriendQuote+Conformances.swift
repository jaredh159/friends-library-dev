// auto-generated, do not edit
import Foundation
import Tagged

extension FriendQuote: ApiModel {
  typealias Id = Tagged<FriendQuote, UUID>
  static var preloadedEntityType: PreloadedEntityType? {
    .friendQuote(Self.self)
  }
}

extension FriendQuote: DuetModel {
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
        return .id(self) == constraint.value
      case .friendId:
        return .uuid(friendId) == constraint.value
      case .source:
        return .string(source) == constraint.value
      case .text:
        return .string(text) == constraint.value
      case .order:
        return .int(order) == constraint.value
      case .context:
        return .string(context) == constraint.value
      case .createdAt:
        return .date(createdAt) == constraint.value
      case .updatedAt:
        return .date(updatedAt) == constraint.value
    }
  }
}

extension FriendQuote: Auditable {}
extension FriendQuote: Touchable {}
