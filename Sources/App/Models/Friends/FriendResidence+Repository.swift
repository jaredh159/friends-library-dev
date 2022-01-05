import FluentSQL
import Vapor

extension Repository where Model == FriendResidence {
  func getDurations(_ id: FriendResidence.Id) async throws -> [FriendResidenceDuration] {
    try await findChildren(id, fk: FriendResidenceDuration[.friendResidenceId])
  }

  func assign(client: inout DatabaseClient) {
    client.getFriendResidenceFriendResidenceDurations = { try await getDurations($0) }
  }
}

extension MockRepository where Model == FriendResidence {
  func getDurations(_ id: FriendResidence.Id) async throws -> [FriendResidenceDuration] {
    db.find(where: { $0.friendResidenceId == id }, in: \.friendResidenceDurations)
  }

  func assign(client: inout DatabaseClient) {
    client.getFriendResidenceFriendResidenceDurations = { try await getDurations($0) }
  }
}
