import FluentSQL
import Vapor
import XCTest

@testable import App

class AppTestCase: XCTestCase {
  static var app: Application!

  override static func setUp() {
    Current = .mock
    Current.uuid = { UUID() }
    app = Application(.testing)
    try! app.autoRevert().wait()
    try! app.autoMigrate().wait()
    try! configure(app)
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
