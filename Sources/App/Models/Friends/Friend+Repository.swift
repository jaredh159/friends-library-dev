import FluentSQL
import Vapor

struct FriendRepository: LiveRepository {
  typealias Model = Friend
  var db: SQLDatabase

  func assign(client: inout DatabaseClient) {
    client.createFriend = { try await create($0) }
    client.createFriends = { try await create($0) }
    client.getFriend = { try await find($0) }
    client.getFriends = { try await select() }
    client.updateFriend = { try await update($0) }
    client.updateFriends = { try await update($0) }
    client.deleteFriend = { try await delete($0) }
    client.deleteAll = { try await deleteAll() }
  }
}

struct MockFriendRepository: MockRepository {
  typealias Model = Friend
  var db: MockDb
  var models: ModelsPath { \.friends }

  func assign(client: inout DatabaseClient) {
    client.createFriend = { try await create($0) }
    client.createFriends = { try await create($0) }
    client.getFriend = { try await find($0) }
    client.getFriends = { try await select() }
    client.updateFriend = { try await update($0) }
    client.updateFriends = { try await update($0) }
    client.deleteFriend = { try await delete($0) }
    client.deleteAll = { try await deleteAll() }
  }
}
