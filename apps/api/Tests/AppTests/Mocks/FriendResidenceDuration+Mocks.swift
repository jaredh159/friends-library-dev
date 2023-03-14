// auto-generated, do not edit
import DuetMock
import GraphQL

@testable import App

extension FriendResidenceDuration {
  static var mock: FriendResidenceDuration {
    FriendResidenceDuration(friendResidenceId: .init(), start: 42, end: 42)
  }

  static var empty: FriendResidenceDuration {
    FriendResidenceDuration(friendResidenceId: .init(), start: 0, end: 0)
  }

  static var random: FriendResidenceDuration {
    FriendResidenceDuration(friendResidenceId: .init(), start: Int.random, end: Int.random)
  }

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "id": .string(id.lowercased),
      "friendResidenceId": .string(friendResidenceId.lowercased),
      "start": .number(Number(start)),
      "end": .number(Number(end)),
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
