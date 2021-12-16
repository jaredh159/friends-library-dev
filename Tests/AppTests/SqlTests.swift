import Vapor
import XCTest

@testable import App

final class SqlTests: XCTestCase {

  func testUpdate() {
    let statement = SQL.update("foos", set: ["bar": 1, "baz": true], where: ("lol", .equals, "a"))

    let prepare = """
      PREPARE testUpdate(numeric, bool, text) AS
        UPDATE "foos"
        SET "bar" = $1, "baz" = $2
        WHERE "lol" = $3;
      """

    let execute = "EXECUTE testUpdate(1, true, 'a');"

    XCTAssertEqual(statement.prepare, prepare)
    XCTAssertEqual(statement.execute, execute)
  }

  func testUpdateWithoutWhere() {
    let statement = SQL.update("foos", set: ["bar": 1])

    let prepare = """
      PREPARE testUpdateWithoutWhere(numeric) AS
        UPDATE "foos"
        SET "bar" = $1;
      """

    let execute = "EXECUTE testUpdateWithoutWhere(1);"

    XCTAssertEqual(statement.prepare, prepare)
    XCTAssertEqual(statement.execute, execute)
  }

  func testUpdateReturning() {
    let statement = SQL.update(
      "foos",
      set: ["bar": 1],
      where: ("lol", .equals, "a"),
      returning: .all
    )

    let prepare = """
      PREPARE testUpdateReturning(numeric, text) AS
        UPDATE "foos"
        SET "bar" = $1
        WHERE "lol" = $2
        RETURNING *;
      """

    let execute = "EXECUTE testUpdateReturning(1, 'a');"

    XCTAssertEqual(statement.prepare, prepare)
    XCTAssertEqual(statement.execute, execute)
  }

  func testBasicInsert() {
    let id = UUID()
    let query = SQL.insert(into: "foos", values: ["a": 33, "b": "lol", "c": .uuid(id)])

    let prepare = """
      PREPARE testBasicInsert(numeric, text, uuid) AS
        INSERT INTO "foos" ("a", "b", "c") VALUES ($1, $2, $3);
      """

    let execute = """
      EXECUTE testBasicInsert(33, 'lol', '\(id.uuidString)');
      """

    XCTAssertEqual(query.prepare, prepare)
    XCTAssertEqual(query.execute, execute)
    XCTAssertEqual(query.name, "testBasicInsert")
  }

  func testOptionalInts() {
    let query = SQL.insert(into: "foos", values: ["a": .int(22), "b": .int(nil)])

    let prepare = """
      PREPARE testOptionalInts(numeric, numeric) AS
        INSERT INTO "foos" ("a", "b") VALUES ($1, $2);
      """

    let execute = """
      EXECUTE testOptionalInts(22, NULL);
      """

    XCTAssertEqual(query.prepare, prepare)
    XCTAssertEqual(query.execute, execute)
  }

  func testOptionalStrings() {
    let query = SQL.insert(into: "foos", values: ["a": "howdy", "b": .string(nil)])

    let prepare = """
      PREPARE testOptionalStrings(text, text) AS
        INSERT INTO "foos" ("a", "b") VALUES ($1, $2);
      """

    let execute = """
      EXECUTE testOptionalStrings('howdy', NULL);
      """

    XCTAssertEqual(query.prepare, prepare)
    XCTAssertEqual(query.execute, execute)
  }

  func testEnums() {
    let query = SQL.insert(
      into: "foos",
      values: [
        "a": .enum(FooBar.foo),
        "b": .enum(FooBar.bar),
        "c": .enum(nil),
      ],
      as: "customName"
    )

    let prepare = """
      PREPARE customName(foobar, foobar, unknown) AS
        INSERT INTO "foos" ("a", "b", "c") VALUES ($1, $2, $3);
      """

    let execute = """
      EXECUTE customName('foo', 'bar', NULL);
      """

    XCTAssertEqual(query.prepare, prepare)
    XCTAssertEqual(query.execute, execute)
  }

  func testDates() {
    let date = Date.fromISOString("2021-12-14T17:16:16.896Z")!
    let query = SQL.insert(into: "foos", values: ["a": .date(date), "b": .currentTimestamp])

    let prepare = """
      PREPARE testDates(timestamp, timestamp) AS
        INSERT INTO "foos" ("a", "b") VALUES ($1, $2);
      """

    let execute = """
      EXECUTE testDates('2021-12-14T17:16:16.896Z', current_timestamp);
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
