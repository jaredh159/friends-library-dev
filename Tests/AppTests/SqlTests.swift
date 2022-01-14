import Foundation
import Tagged
import Vapor
import XCTest

@testable import App

final class SqlTests: XCTestCase {

  func testSimpleSelect() throws {
    let stmt = SQL.select(.all, from: Thing.self)

    let expectedQuery = """
    SELECT * FROM "things";
    """

    XCTAssertEqual(stmt.query, expectedQuery)
    XCTAssertEqual(stmt.bindings, [])
  }

  func testSelectWithLimit() throws {
    let stmt = SQL.select(.all, from: Thing.self, limit: 4)

    let expectedQuery = """
    SELECT * FROM "things"
    LIMIT 4;
    """

    XCTAssertEqual(stmt.query, expectedQuery)
    XCTAssertEqual(stmt.bindings, [])
  }

  func testSelectWithSingleWhere() throws {
    let stmt = SQL.select(.all, from: Thing.self, where: ["id" == 123])

    let expectedQuery = """
    SELECT * FROM "things"
    WHERE "id" = $1;
    """

    XCTAssertEqual(stmt.query, expectedQuery)
    XCTAssertEqual(stmt.bindings, [123])
  }

  func testSelectWithMultipleWheres() throws {
    let stmt = SQL.select(.all, from: Thing.self, where: ["id" == 123, "foo" == 789])

    let expectedQuery = """
    SELECT * FROM "things"
    WHERE "id" = $1
    AND "foo" = $2;
    """

    XCTAssertEqual(stmt.query, expectedQuery)
    XCTAssertEqual(stmt.bindings, [123, 789])
  }

  func testDeleteWithConstraint() throws {
    let stmt = SQL.delete(from: Thing.tableName, where: ["id" == 123])

    let expectedQuery = """
    DELETE FROM "things" WHERE "id" = $1;
    """

    XCTAssertEqual(stmt.query, expectedQuery)
    XCTAssertEqual(stmt.bindings, [123])
  }

  func testDeleteAll() throws {
    let stmt = SQL.delete(from: Thing.tableName)

    let expectedQuery = """
    DELETE FROM "things";
    """

    XCTAssertEqual(stmt.query, expectedQuery)
    XCTAssertEqual(stmt.bindings, [])
  }

  func testBulkInsert() throws {
    let stmt = try SQL.insert(into: "things", values: [["foo": 1, "bar": 2], ["bar": 4, "foo": 3]])

    let expectedQuery = """
    INSERT INTO "things"
    ("bar", "foo")
    VALUES
    ($1, $2), ($3, $4);
    """

    XCTAssertEqual(stmt.query, expectedQuery)
    XCTAssertEqual(stmt.bindings, [2, 1, 4, 3])
  }

  func testUpdate() {
    let statement = SQL.update(
      "things",
      set: ["bar": 1, "baz": true],
      where: [("lol", .equals, "a")]
    )

    let query = """
    UPDATE "things"
    SET "bar" = $1, "baz" = $2
    WHERE "lol" = $3;
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [1, true, "a"])
  }

  func testUpdateWithoutWhere() {
    let statement = SQL.update("things", set: ["bar": 1])

    let query = """
    UPDATE "things"
    SET "bar" = $1;
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [1])
  }

  func testUpdateReturning() {
    let statement = SQL.update(
      "things",
      set: ["bar": 1],
      where: [("lol", .equals, "a")],
      returning: .all
    )

    let query = """
    UPDATE "things"
    SET "bar" = $1
    WHERE "lol" = $2
    RETURNING *;
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [1, "a"])
  }

  func testBasicInsert() throws {
    let id = UUID()
    let statement = try SQL.insert(into: "things", values: ["a": 33, "b": "lol", "c": .uuid(id)])

    let query = """
    INSERT INTO "things"
    ("a", "b", "c")
    VALUES
    ($1, $2, $3);
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [33, "lol", .uuid(id)])
  }

  func testOptionalInts() throws {
    let statement = try SQL.insert(into: "things", values: ["a": .int(22), "b": .int(nil)])

    let query = """
    INSERT INTO "things"
    ("a", "b")
    VALUES
    ($1, $2);
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [22, .int(nil)])
  }

  func testOptionalStrings() throws {
    let statement = try SQL.insert(into: "things", values: ["a": "howdy", "b": .string(nil)])

    let query = """
    INSERT INTO "things"
    ("a", "b")
    VALUES
    ($1, $2);
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, ["howdy", .string(nil)])
  }

  func testEnums() throws {
    let statement = try SQL.insert(
      into: "things",
      values: [
        "a": .enum(FooBar.foo),
        "b": .enum(FooBar.bar),
        "c": .enum(nil),
      ]
    )

    let query = """
    INSERT INTO "things"
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
      into: "things", values: ["a": .date(date), "b": .currentTimestamp]
    )

    let query = """
    INSERT INTO "things"
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
