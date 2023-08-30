import FluentSQL
import GraphQLKit
import Vapor
import XCTest
import XSendGrid

@testable import App
@testable import DuetSQL

class AppTestCase: XCTestCase {
  struct Sent {
    var slacks: [FlpSlack.Message] = []
    var emails: [SendGrid.Email] = []
  }

  static var app: Application!
  var sent = Sent()

  var app: Application {
    Self.app
  }

  override static func setUp() {
    Current = .mock
    Current.uuid = { UUID() }
    app = Application(.testing)
    Current.logger = .null
    try! app.autoRevert().wait()
    try! app.autoMigrate().wait()
    try! Configure.app(app)
    app.logger = .null
    Current.logger = .null
    Current.db = MockClient()
  }

  override static func tearDown() {
    app.shutdown()
    sync { await SQL.resetPreparedStatements() }
  }

  override func setUp() {
    let existingDb = Current.db
    Current = .mock
    Current.uuid = { UUID() }
    Current.date = { Date() }
    if ProcessInfo.processInfo.environment["TEST_WITH_POSTGRES"] != nil {
      Current.db = LiveDatabase(db: app.db as! SQLDatabase)
    } else {
      Current.db = existingDb
    }
    Current.slackClient.send = { [self] in sent.slacks.append($0) }
    Current.sendGridClient.send = { [self] in sent.emails.append($0) }
  }

  public func assertResponse(
    to operation: String,
    bearer: UUID? = nil,
    addingHeaders headers: [HTTPHeaders.Name: String]? = nil,
    withVariables variables: [String: Map]? = nil,
    _ expectedData: ExpectedData,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    assertGraphQLResponse(
      to: operation,
      auth: bearer == nil ? nil : .bearer(bearer!.lowercased),
      addingHeaders: headers,
      withVariables: variables,
      on: app,
      expectedData,
      file: file,
      line: line
    )
  }

  public func assertResponse(
    to operation: String,
    bearer: UUID? = nil,
    addingHeaders headers: [HTTPHeaders.Name: String]? = nil,
    withVariables variables: [String: Map]? = nil,
    isError expectedError: ExpectedError,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    assertGraphQLResponse(
      to: operation,
      auth: bearer == nil ? nil : .bearer(bearer!.lowercased),
      addingHeaders: headers,
      withVariables: variables,
      on: app,
      isError: expectedError,
      file: file,
      line: line
    )
  }
}

func mockUUIDs() -> (UUID, UUID, UUID) {
  let uuids = (UUID(), UUID(), UUID())
  var array = [uuids.0, uuids.1, uuids.2]

  UUID.new = {
    guard !array.isEmpty else { return UUID() }
    return array.removeFirst()
  }

  return uuids
}

public extension String {
  var random: String { "\(self)@random-\(Int.random)" }
}

public extension Int {
  static var random: Int { Int.random(in: 1_000_000_000 ... 9_999_999_999) }
}

public extension Int64 {
  static var random: Int64 { Int64.random(in: 1_000_000_000 ... 9_999_999_999) }
}

func sync(
  function: StaticString = #function,
  line: UInt = #line,
  column: UInt = #column,
  _ f: @escaping () async throws -> Void
) {
  let exp = XCTestExpectation(description: "sync:\(function):\(line):\(column)")
  Task {
    do {
      try await f()
      exp.fulfill()
    } catch {
      fatalError("Error awaiting \(exp.description) -- \(error)")
    }
  }
  switch XCTWaiter.wait(for: [exp], timeout: 10) {
  case .completed:
    return
  case .timedOut:
    fatalError("Timed out waiting for \(exp.description)")
  default:
    fatalError("Unexpected result waiting for \(exp.description)")
  }
}
