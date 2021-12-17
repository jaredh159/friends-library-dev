import Vapor
import XCTest

@testable import App

final class TokenRepositoryTests: AppTestCase {

  func testCreateToken() {
    let inserted = Token(description: "test")
    _ = try! Current.db.createToken(inserted).wait()
    let retrieved = try! Current.db.getTokenByValue(inserted.value).wait()
    XCTAssertEqual(retrieved, inserted)
  }
}
