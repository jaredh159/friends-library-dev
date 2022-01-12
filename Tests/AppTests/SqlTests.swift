import Vapor
import XCTest

@testable import App

final class SqlTests: XCTestCase {

  func testDeleteWithConstraint() throws {
    let stmt = SQL.delete(from: "foos", where: "id" == "abc")

    let expectedQuery = """
    DELETE FROM "foos" WHERE "id" = $1;
    """

    XCTAssertEqual(stmt.query, expectedQuery)
    XCTAssertEqual(stmt.bindings, ["abc"])
  }

  func testDeleteAll() throws {
    let stmt = SQL.delete(from: "foos")

    let expectedQuery = """
    DELETE FROM "foos";
    """

    XCTAssertEqual(stmt.query, expectedQuery)
    XCTAssertEqual(stmt.bindings, [])
  }

  func testBulkInsert() throws {
    let stmt = try SQL.insert(into: "foos", values: [["foo": 1, "bar": 2], ["bar": 4, "foo": 3]])

    let expectedQuery = """
    INSERT INTO "foos"
    ("bar", "foo")
    VALUES
    ($1, $2), ($3, $4);
    """

    XCTAssertEqual(stmt.query, expectedQuery)
    XCTAssertEqual(stmt.bindings, [2, 1, 4, 3])
  }

  func testUpdate() {
    let statement = SQL.update("foos", set: ["bar": 1, "baz": true], where: ("lol", .equals, "a"))

    let query = """
    UPDATE "foos"
    SET "bar" = $1, "baz" = $2
    WHERE "lol" = $3;
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [1, true, "a"])
  }

  func testUpdateWithoutWhere() {
    let statement = SQL.update("foos", set: ["bar": 1])

    let query = """
    UPDATE "foos"
    SET "bar" = $1;
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [1])
  }

  func testUpdateReturning() {
    let statement = SQL.update(
      "foos",
      set: ["bar": 1],
      where: ("lol", .equals, "a"),
      returning: .all
    )

    let query = """
    UPDATE "foos"
    SET "bar" = $1
    WHERE "lol" = $2
    RETURNING *;
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [1, "a"])
  }

  func testBasicInsert() throws {
    let id = UUID()
    let statement = try SQL.insert(into: "foos", values: ["a": 33, "b": "lol", "c": .uuid(id)])

    let query = """
    INSERT INTO "foos"
    ("a", "b", "c")
    VALUES
    ($1, $2, $3);
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [33, "lol", .uuid(id)])
  }

  func testOptionalInts() throws {
    let statement = try SQL.insert(into: "foos", values: ["a": .int(22), "b": .int(nil)])

    let query = """
    INSERT INTO "foos"
    ("a", "b")
    VALUES
    ($1, $2);
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [22, .int(nil)])
  }

  func testOptionalStrings() throws {
    let statement = try SQL.insert(into: "foos", values: ["a": "howdy", "b": .string(nil)])

    let query = """
    INSERT INTO "foos"
    ("a", "b")
    VALUES
    ($1, $2);
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, ["howdy", .string(nil)])
  }

  func testEnums() throws {
    let statement = try SQL.insert(
      into: "foos",
      values: [
        "a": .enum(FooBar.foo),
        "b": .enum(FooBar.bar),
        "c": .enum(nil),
      ]
    )

    let query = """
    INSERT INTO "foos"
    ("a", "b", "c")
    VALUES
    ($1, $2, $3);
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [.enum(FooBar.foo), .enum(FooBar.bar), .enum(nil)])
  }

  func testDates() throws {
    let date = Date.fromISOString("2021-12-14T17:16:16.896Z")!
    let statement = try SQL.insert(
      into: "foos", values: ["a": .date(date), "b": .currentTimestamp]
    )

    let query = """
    INSERT INTO "foos"
    ("a", "b")
    VALUES
    ($1, $2);
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [.date(date), .currentTimestamp])
  }
}

enum FooBar: String {
  case foo, bar
}

extension FooBar: PostgresEnum {
  var dataType: String { "foobar" }
}
