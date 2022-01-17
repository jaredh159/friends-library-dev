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
    let stmt = SQL.select(.all, from: Thing.self, where: [.id == 123])

    let expectedQuery = """
    SELECT * FROM "things"
    WHERE "id" = $1;
    """

    XCTAssertEqual(stmt.query, expectedQuery)
    XCTAssertEqual(stmt.bindings, [123])
  }

  func testSelectWithMultipleWheres() throws {
    let stmt = SQL.select(.all, from: Thing.self, where: [.id == 123, .foo == 789])

    let expectedQuery = """
    SELECT * FROM "things"
    WHERE "id" = $1
    AND "foo" = $2;
    """

    XCTAssertEqual(stmt.query, expectedQuery)
    XCTAssertEqual(stmt.bindings, [123, 789])
  }

  func testDeleteWithConstraint() throws {
    let stmt = SQL.delete(from: Thing.self, where: [.id == 123])

    let expectedQuery = """
    DELETE FROM "things"
    WHERE "id" = $1;
    """

    XCTAssertEqual(stmt.query, expectedQuery)
    XCTAssertEqual(stmt.bindings, [123])
  }

  func testDeleteWithOrderByAndLimit() throws {
    let stmt = SQL.delete(
      from: Thing.self,
      where: [.id == 123],
      orderBy: .init(.createdAt, .asc),
      limit: 1
    )

    let expectedQuery = """
    DELETE FROM "things"
    WHERE "id" = $1
    ORDER BY "created_at" ASC
    LIMIT 1;
    """

    XCTAssertEqual(stmt.query, expectedQuery)
    XCTAssertEqual(stmt.bindings, [123])
  }

  func testDeleteAll() throws {
    let stmt = SQL.delete(from: Thing.self)

    let expectedQuery = """
    DELETE FROM "things";
    """

    XCTAssertEqual(stmt.query, expectedQuery)
    XCTAssertEqual(stmt.bindings, [])
  }

  func testBulkInsert() throws {
    let stmt = try SQL.insert(into: Thing.self, values: [[.foo: 1, .bar: 2], [.bar: 4, .foo: 3]])

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
    let statement = SQL.update(Thing.self, set: [.bar: 1, .baz: true], where: [.foo == "a"])

    let query = """
    UPDATE "things"
    SET "bar" = $1, "baz" = $2
    WHERE "foo" = $3;
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [1, true, "a"])
  }

  func testUpdateWithoutWhere() {
    let statement = SQL.update(Thing.self, set: [.bar: 1])

    let query = """
    UPDATE "things"
    SET "bar" = $1;
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [1])
  }

  func testUpdateReturning() {
    let statement = SQL.update(
      Thing.self,
      set: [.bar: 1],
      where: [.foo == "a"],
      returning: .all
    )

    let query = """
    UPDATE "things"
    SET "bar" = $1
    WHERE "foo" = $2
    RETURNING *;
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [1, "a"])
  }

  func testBasicInsert() throws {
    let id = UUID()
    let statement = try SQL.insert(
      into: Thing.self,
      values: [.bar: 33, .foo: "lol", .id: .uuid(id)]
    )

    let query = """
    INSERT INTO "things"
    ("bar", "foo", "id")
    VALUES
    ($1, $2, $3);
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [33, "lol", .uuid(id)])
  }

  func testOptionalInts() throws {
    let statement = try SQL.insert(into: Thing.self, values: [.bar: .int(22), .optBar: .int(nil)])

    let query = """
    INSERT INTO "things"
    ("bar", "opt_bar")
    VALUES
    ($1, $2);
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [22, .int(nil)])
  }

  func testOptionalStrings() throws {
    let statement = try SQL.insert(into: Thing.self, values: [.foo: "howdy", .optFoo: .string(nil)])

    let query = """
    INSERT INTO "things"
    ("foo", "opt_foo")
    VALUES
    ($1, $2);
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, ["howdy", .string(nil)])
  }

  func testEnums() throws {
    let statement = try SQL.insert(
      into: Thing.self,
      values: [
        .foobar: .enum(FooBar.foo),
        .optFoobar: .enum(nil),
      ]
    )

    let query = """
    INSERT INTO "things"
    ("foobar", "opt_foobar")
    VALUES
    ($1, $2);
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [.enum(FooBar.foo), .enum(nil)])
  }

  func testDates() throws {
    let date = Date.fromISOString("2021-12-14T17:16:16.896Z")!
    let statement = try SQL.insert(
      into: Thing.self,
      values: [.createdAt: .date(date), .updatedAt: .currentTimestamp]
    )

    let query = """
    INSERT INTO "things"
    ("created_at", "updated_at")
    VALUES
    ($1, $2);
    """

    XCTAssertEqual(statement.query, query)
    XCTAssertEqual(statement.bindings, [.date(date), .currentTimestamp])
  }

  func testUpdateRemovesIdAndCreatedAtFromInsertValues() throws {
    let thing = Thing(foo: "foo", bar: 0, baz: true, foobar: .foo)
    let statement = SQL.update(Thing.self, set: thing.insertValues)

    let query = """
    UPDATE "things"
    SET "updated_at" = $1, "foo" = $2, "opt_bar" = $3, "opt_foobar" = $4, "bar" = $5, "opt_foo" = $6, "foobar" = $7, "baz" = $8;
    """

    XCTAssertEqual(statement.query, query)
  }
}

enum FooBar: String {
  case foo, bar
}

extension FooBar: PostgresEnum {
  var dataType: String { "foobar" }
}
