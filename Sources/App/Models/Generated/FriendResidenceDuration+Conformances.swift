// auto-generated, do not edit
import Foundation
import Tagged

extension FriendResidenceDuration: AppModel {
  typealias Id = Tagged<FriendResidenceDuration, UUID>
}

extension FriendResidenceDuration: DuetModel {
  static let tableName = "friend_residence_durations"
}

extension FriendResidenceDuration {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.friendResidenceId]: .uuid(friendResidenceId),
      Self[.start]: .int(start),
      Self[.end]: .int(end),
      Self[.createdAt]: .currentTimestamp,
    ]
  }
}

extension FriendResidenceDuration {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case friendResidenceId
    case start
    case end
    case createdAt
  }
}

extension FriendResidenceDuration: Auditable {}
