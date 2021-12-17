import Vapor
import XCTest

@testable import App

final class DownloadRepositoryTests: AppTestCase {

  func testCreateAndGet() {
    // temp, until FK issue
    let oldDb = Current.db
    Current.db = .mock(eventLoop: Self.app.eventLoopGroup.next())

    let inserted: Download = .mock
    _ = try! Current.db.createDownload(inserted).wait()

    let retrieved = try! Current.db.getDownload(inserted.id).wait()

    XCTAssertEqual(inserted, retrieved)

    Current.db = oldDb
  }
}
