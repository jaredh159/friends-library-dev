import GraphQL
import XCTVapor

@testable import App

final class JsErrorLoggingTests: AppTestCase {

  func testLoggingJsError() async throws {
    let input: Map = .dictionary([
      "userAgent": "operafox",
      "url": "/some-url",
      "location": "/some-location",
      "lineNumber": 33,
    ])

    assertResponse(
      to: /* gql */ """
      mutation logJsError($input: LogJsErrorDataInput!) {
        logJsError(input: $input) {
          success
        }
      }
      """,
      withVariables: ["input": input],
      .containsKeyValuePairs(["success": true])
    )

    XCTAssertEqual(sent.slacks.count, 1)
    XCTAssertEqual(sent.slacks.first?.channel, .errors)
    XCTAssertContains(sent.slacks.first?.message.text, "operafox")
  }
}
