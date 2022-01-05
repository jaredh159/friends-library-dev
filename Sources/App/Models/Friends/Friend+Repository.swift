import FluentSQL
import Vapor

extension Repository where Model == Friend {
  func getDocuments(_ id: Friend.Id) async throws -> [Document] {
    try await findChildren(id, fk: Document[.friendId])
  }

  func getResidences(_ id: Friend.Id) async throws -> [FriendResidence] {
    try await findChildren(id, fk: FriendResidence[.friendId])
  }

  func getQuotes(_ id: Friend.Id) async throws -> [FriendQuote] {
    try await findChildren(id, fk: FriendQuote[.friendId])
  }

  func assign(client: inout DatabaseClient) {
    client.getFriendDocuments = { try await getDocuments($0) }
    client.getFriendFriendResidences = { try await getResidences($0) }
    client.getFriendFriendQuotes = { try await getQuotes($0) }
  }
}

extension MockRepository where Model == Friend {
  func getDocuments(_ id: Friend.Id) async throws -> [Document] {
    db.find(where: { $0.friendId == id }, in: \.documents)
  }

  func getResidences(_ id: Friend.Id) async throws -> [FriendResidence] {
    db.find(where: { $0.friendId == id }, in: \.friendResidences)
  }

  func getQuotes(_ id: Friend.Id) async throws -> [FriendQuote] {
    db.find(where: { $0.friendId == id }, in: \.friendQuotes)
  }

  func assign(client: inout DatabaseClient) {
    client.getFriendDocuments = { try await getDocuments($0) }
    client.getFriendFriendResidences = { try await getResidences($0) }
    client.getFriendFriendQuotes = { try await getQuotes($0) }
  }
}
