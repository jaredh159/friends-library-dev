import FluentSQL
import Vapor
import XCTest

@testable import App

class AppTestCase: XCTestCase {
  static var app: Application!

  override static func setUp() {
    app = Application(.testing)
    try! app.autoRevert().wait()
    try! app.autoMigrate().wait()
    Current = .mock
    try! configure(app)
    Current.uuid = { UUID() }
    Current.logger = .null
    Current.db = MockDatabase()
  }

  override static func tearDown() {
    app.shutdown()
    let exp = XCTestExpectation(description: "reset complete")
    Task {
      await SQL.resetPreparedStatements()
      exp.fulfill()
    }
    _ = XCTWaiter.wait(for: [exp], timeout: 1)
  }

  override func setUp() {
    let existingDb = Current.db
    Current = .mock
    Current.uuid = { UUID() }
    Current.date = { Date() }
    Current.db = existingDb
  }
}
