import Vapor
import XCTest

@testable import App

final class TokenRepositoryTests: AppTestCase {

  func testCreateToken() async throws {
    let inserted = Token(description: "test")
    _ = try await Current.db.createToken(inserted)
    let retrieved = try await Current.db.getTokenByValue(inserted.value)
    XCTAssertEqual(retrieved, inserted)
  }
}
