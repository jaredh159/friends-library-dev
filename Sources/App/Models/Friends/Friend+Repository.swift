import FluentSQL
import Vapor

struct FriendRepository: LiveRepository {
  typealias Model = Friend
  var db: SQLDatabase

  func getDocuments(_ id: Friend.Id) async throws -> [Document] {
    try await findChildren(id, fk: Document[.friendId])
  }

  func assign(client: inout DatabaseClient) {
    client.createFriend = { try await create($0) }
    client.createFriends = { try await create($0) }
    client.getFriend = { try await find($0) }
    client.getFriends = { try await select() }
    client.getFriendDocuments = { try await getDocuments($0) }
    client.updateFriend = { try await update($0) }
    client.updateFriends = { try await update($0) }
    client.deleteFriend = { try await delete($0) }
    client.deleteAllFriends = { try await deleteAll() }
  }
}

struct MockFriendRepository: MockRepository {
  typealias Model = Friend
  var db: MockDb
  var models: ModelsPath { \.friends }

  func getDocuments(_ id: Friend.Id) async throws -> [Document] {
    db.find(where: { $0.friendId == id }, in: \.documents)
  }

  func assign(client: inout DatabaseClient) {
    client.createFriend = { try await create($0) }
    client.createFriends = { try await create($0) }
    client.getFriend = { try await find($0) }
    client.getFriends = { try await select() }
    client.getFriendDocuments = { try await getDocuments($0) }
    client.updateFriend = { try await update($0) }
    client.updateFriends = { try await update($0) }
    client.deleteFriend = { try await delete($0) }
    client.deleteAllFriends = { try await deleteAll() }
  }
}
