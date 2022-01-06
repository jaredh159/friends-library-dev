import FluentSQL
import Vapor

extension Repository where Model == Token {
  func getTokenByValue(_ value: Token.Value) async throws -> Token {
    return try await find(where: Token[.value] == .uuid(value))
  }

  func assign(client: inout DatabaseClient) {
    client.getTokenByValue = { try await getTokenByValue($0) }
  }
}

extension MockRepository where Model == Token {
  func getTokenByValue(_ value: Token.Value) async throws -> Token {
    return try await find(where: Token[.value] == .uuid(value))
  }

  func assign(client: inout DatabaseClient) {
    client.getTokenByValue = { try await getTokenByValue($0) }
  }
}
