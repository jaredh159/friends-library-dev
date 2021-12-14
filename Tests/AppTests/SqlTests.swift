import Vapor
import XCTest

@testable import App

final class SqlTests: XCTestCase {

  func testBasicInsert() {
    let id = UUID()
    let query = insert(
      into: "foos",
      values: ["a": .int(33), "b": .string("lol"), "c": .uuid(id)]
    )

    let prepare = """
      PREPARE insert_foo(numeric, text, uuid) AS
        INSERT INTO "foos" ("a", "b", "c") VALUES ($1, $2, $3);
      """

    let execute = """
      EXECUTE insert_foo(33, 'lol', '\(id.uuidString)');
      """

    XCTAssertEqual(query.prepare, prepare)
    XCTAssertEqual(query.execute, execute)
    XCTAssertEqual(query.name, "insert_foo")
  }

  func testOptionalInts() {
    let query = insert(
      into: "foos",
      values: ["a": .int(22), "b": .int(nil)]
    )

    let prepare = """
      PREPARE insert_foo(numeric, numeric) AS
        INSERT INTO "foos" ("a", "b") VALUES ($1, $2);
      """

    let execute = """
      EXECUTE insert_foo(22, NULL);
      """

    XCTAssertEqual(query.prepare, prepare)
    XCTAssertEqual(query.execute, execute)
  }

  func testOptionalStrings() {
    let query = insert(
      into: "foos",
      values: ["a": .string("howdy"), "b": .string(nil)]
    )

    let prepare = """
      PREPARE insert_foo(text, text) AS
        INSERT INTO "foos" ("a", "b") VALUES ($1, $2);
      """

    let execute = """
      EXECUTE insert_foo('howdy', NULL);
      """

    XCTAssertEqual(query.prepare, prepare)
    XCTAssertEqual(query.execute, execute)
  }

  func testEnums() {
    let query = insert(
      into: "foos",
      values: [
        "a": .enum(FooBar.foo),
        "b": .enum(FooBar.bar),
        "c": .enum(nil),
      ],
      as: "custom_name"
    )

    let prepare = """
      PREPARE custom_name(foobar, foobar, unknown) AS
        INSERT INTO "foos" ("a", "b", "c") VALUES ($1, $2, $3);
      """

    let execute = """
      EXECUTE custom_name('foo', 'bar', NULL);
      """

    XCTAssertEqual(query.prepare, prepare)
    XCTAssertEqual(query.execute, execute)
  }

  func testDates() {
    let date = Date.fromISOString("2021-12-14T17:16:16.896Z")!
    let query = insert(into: "foos", values: ["a": .date(date), "b": .currentTimestamp])

    let prepare = """
      PREPARE insert_foo(timestamp, timestamp) AS
        INSERT INTO "foos" ("a", "b") VALUES ($1, $2);
      """

    let execute = """
      EXECUTE insert_foo('2021-12-14T17:16:16.896Z', current_timestamp);
      """

    XCTAssertEqual(query.prepare, prepare)
    XCTAssertEqual(query.execute, execute)
  }
}

enum FooBar: String {
  case foo, bar
}

extension FooBar: PostgresEnum {
  var dataType: String { "foobar" }
}
