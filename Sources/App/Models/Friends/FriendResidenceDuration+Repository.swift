
import FluentSQL
import Vapor

struct FriendResidenceDurationRepository: LiveRepository {
  typealias Model = FriendResidenceDuration
  var db: SQLDatabase

  func assign(client: inout DatabaseClient) {
    client.createFriendResidenceDuration = { try await create($0) }
    client.createFriendResidenceDurations = { try await create($0) }
    client.getFriendResidenceDuration = { try await find($0) }
    client.getFriendResidenceDurations = { try await select() }
    client.updateFriendResidenceDuration = { try await update($0) }
    client.updateFriendResidenceDurations = { try await update($0) }
    client.deleteFriendResidenceDuration = { try await delete($0) }
    client.deleteAllFriendResidenceDurations = { try await deleteAll() }
  }
}

struct MockFriendResidenceDurationRepository: MockRepository {
  typealias Model = FriendResidenceDuration
  var db: MockDb
  var models: ModelsPath { \.friendResidenceDurations }

  func assign(client: inout DatabaseClient) {
    client.createFriendResidenceDuration = { try await create($0) }
    client.createFriendResidenceDurations = { try await create($0) }
    client.getFriendResidenceDuration = { try await find($0) }
    client.getFriendResidenceDurations = { try await select() }
    client.updateFriendResidenceDuration = { try await update($0) }
    client.updateFriendResidenceDurations = { try await update($0) }
    client.deleteFriendResidenceDuration = { try await delete($0) }
    client.deleteAllFriendResidenceDurations = { try await deleteAll() }
  }
}
