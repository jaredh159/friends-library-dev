// auto-generated, do not edit
import Foundation
import Tagged

extension FriendResidence: ApiModel {
  typealias Id = Tagged<FriendResidence, UUID>
  static var preloadedEntityType: PreloadedEntityType? {
    .friendResidence(Self.self)
  }
}

extension FriendResidence: DuetModel {
  static let tableName = M12.tableName
  static var isSoftDeletable: Bool { false }
}

extension FriendResidence {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case friendId
    case city
    case region
    case createdAt
    case updatedAt
  }
}

extension FriendResidence {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .friendId: .uuid(friendId),
      .city: .string(city),
      .region: .string(region),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }
}

extension FriendResidence: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<FriendResidence>) -> Bool {
    switch constraint.column {
      case .id:
        return constraint.isSatisfiedBy(.id(self))
      case .friendId:
        return constraint.isSatisfiedBy(.uuid(friendId))
      case .city:
        return constraint.isSatisfiedBy(.string(city))
      case .region:
        return constraint.isSatisfiedBy(.string(region))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
      case .updatedAt:
        return constraint.isSatisfiedBy(.date(updatedAt))
    }
  }
}

extension FriendResidence: Auditable {}
extension FriendResidence: Touchable {}
