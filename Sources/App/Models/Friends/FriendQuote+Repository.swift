
import FluentSQL
import Vapor

struct FriendQuoteRepository: LiveRepository {
  typealias Model = FriendQuote
  var db: SQLDatabase

  func assign(client: inout DatabaseClient) {
    client.createFriendQuote = { try await create($0) }
    client.createFriendQuotes = { try await create($0) }
    client.getFriendQuote = { try await find($0) }
    client.getFriendQuotes = { try await select() }
    client.updateFriendQuote = { try await update($0) }
    client.updateFriendQuotes = { try await update($0) }
    client.deleteFriendQuote = { try await delete($0) }
    client.deleteAllFriendQuotes = { try await deleteAll() }
  }
}

struct MockFriendQuoteRepository: MockRepository {
  typealias Model = FriendQuote
  var db: MockDb
  var models: ModelsPath { \.friendQuotes }

  func assign(client: inout DatabaseClient) {
    client.createFriendQuote = { try await create($0) }
    client.createFriendQuotes = { try await create($0) }
    client.getFriendQuote = { try await find($0) }
    client.getFriendQuotes = { try await select() }
    client.updateFriendQuote = { try await update($0) }
    client.updateFriendQuotes = { try await update($0) }
    client.deleteFriendQuote = { try await delete($0) }
    client.deleteAllFriendQuotes = { try await deleteAll() }
  }
}
