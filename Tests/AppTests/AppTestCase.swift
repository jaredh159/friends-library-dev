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
  }

  override static func tearDown() {
    app.shutdown()
    SQL.resetPreparedStatements()
  }

  override func setUp() {
    Current.db = .mock(eventLoop: Self.app.db.eventLoop)
    Current.auth = .mockWithAllScopes
  }
}
