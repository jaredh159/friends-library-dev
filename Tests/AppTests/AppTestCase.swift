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
    SQL.resetPreparedStatements()
  }

  override func setUp() {
    Current.db = MockDatabase()
    Current.auth = .mockWithAllScopes
  }
}
