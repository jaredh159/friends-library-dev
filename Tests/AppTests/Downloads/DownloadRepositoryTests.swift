import Vapor
import XCTest

@testable import App

final class DownloadRepositoryTests: AppTestCase {

  func testCreateAndGet() async throws {
    // temp, until FK issue
    let oldDb = Current.db
    Current.db = .mock

    let inserted: Download = .mock
    try await Current.db.createDownload(inserted)
    let retrieved = try await Current.db.getDownload(inserted.id)

    XCTAssertEqual(inserted, retrieved)

    Current.db = oldDb
  }
}
