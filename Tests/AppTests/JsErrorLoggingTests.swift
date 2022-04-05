import Foundation
import GraphQL
import XCTVapor
import XCTVaporUtils

@testable import App

final class JsErrorLoggingTests: AppTestCase {

  func testLoggingJsError() async throws {
    let input: Map = .dictionary([
      "userAgent": "operafox",
      "url": "/some-url",
      "location": "/some-location",
      "lineNumber": 33,
    ])

    GraphQLTest(
      """
      mutation logJsError($input: LogJsErrorDataInput!) {
        logJsError(input: $input) {
          success
        }
      }
      """,
      expectedData: .containsKVPs(["success": true])
    ).run(Self.app, variables: ["input": input])

    XCTAssertEqual(sent.slacks.count, 1)
    XCTAssertEqual(sent.slacks.first?.channel, .errors)
    XCTAssertContains(sent.slacks.first?.message.text, "operafox")
  }
}
