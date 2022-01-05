import FluentSQL
import Vapor

extension Repository where Model == Friend {
  func getDocuments(_ id: Friend.Id) async throws -> [Document] {
    try await findChildren(id, fk: Document[.friendId])
  }

  func assign(client: inout DatabaseClient) {
    client.getFriendDocuments = { try await getDocuments($0) }
  }
}

extension MockRepository where Model == Friend {
  func getDocuments(_ id: Friend.Id) async throws -> [Document] {
    db.find(where: { $0.friendId == id }, in: \.documents)
  }

  func assign(client: inout DatabaseClient) {
    client.getFriendDocuments = { try await getDocuments($0) }
  }
}
