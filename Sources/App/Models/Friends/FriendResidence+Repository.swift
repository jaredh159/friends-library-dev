
import FluentSQL
import Vapor

struct FriendResidenceRepository: LiveRepository {
  typealias Model = FriendResidence
  var db: SQLDatabase

  func assign(client: inout DatabaseClient) {
    client.createFriendResidence = { try await create($0) }
    client.createFriendResidences = { try await create($0) }
    client.getFriendResidence = { try await find($0) }
    client.getFriendResidences = { try await select() }
    client.updateFriendResidence = { try await update($0) }
    client.updateFriendResidences = { try await update($0) }
    client.deleteFriendResidence = { try await delete($0) }
    client.deleteAllFriendResidences = { try await deleteAll() }
  }
}

struct MockFriendResidenceRepository: MockRepository {
  typealias Model = FriendResidence
  var db: MockDb
  var models: ModelsPath { \.friendResidences }

  func assign(client: inout DatabaseClient) {
    client.createFriendResidence = { try await create($0) }
    client.createFriendResidences = { try await create($0) }
    client.getFriendResidence = { try await find($0) }
    client.getFriendResidences = { try await select() }
    client.updateFriendResidence = { try await update($0) }
    client.updateFriendResidences = { try await update($0) }
    client.deleteFriendResidence = { try await delete($0) }
    client.deleteAllFriendResidences = { try await deleteAll() }
  }
}
