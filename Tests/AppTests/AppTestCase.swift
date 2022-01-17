import Vapor
import XCTest

@testable import App

class AppTestCase: XCTestCase {
  static var app: Application!

  override static func setUp() {
    app = Application(.testing)
    try! app.autoRevert().wait()
    try! app.autoMigrate().wait()
    try! configure(app)
    Current.logger = .null
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
    Current.db = MockDatabase()
    Current.auth = .mockWithAllScopes
  }
}
