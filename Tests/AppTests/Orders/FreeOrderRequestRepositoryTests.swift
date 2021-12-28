import Vapor
import XCTest

@testable import App

final class FreeOrderRequestRepositoryTests: AppTestCase {

  func testCreateAndGet() async throws {
    let inserted: FreeOrderRequest = .mock
    try await Current.db.createFreeOrderRequest(inserted)
    let retrieved = try await Current.db.getFreeOrderRequest(inserted.id)
    XCTAssertEqual(inserted, retrieved)
  }
}
