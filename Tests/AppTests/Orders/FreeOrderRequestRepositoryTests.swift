import Vapor
import XCTest

@testable import App

final class FreeOrderRequestRepositoryTests: AppTestCase {

  func testCreateAndGet() {
    let inserted: FreeOrderRequest = .mock
    _ = try! Current.db.createFreeOrderRequest(inserted).wait()

    let retrieved = try! Current.db.getFreeOrderRequest(inserted.id).wait()

    XCTAssertEqual(inserted, retrieved)
  }
}
