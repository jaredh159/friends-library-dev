import Vapor
import XCTest

@testable import App

final class OrderRepositoryTests: XCTestCase {
  static var app: Application!

  override static func setUp() {
    app = Application(.testing)
    try! app.autoRevert().wait()
    try! app.autoMigrate().wait()
    try! configure(app)
  }

  override func setUp() {
    // Current.db = .mock(eventLoop: Self.app.db.eventLoop)
  }

  func testInsertingAndRetrievingOrder() throws {
    let inserted: Order = .empty
    inserted.addressName = "Bob"

    _ = try Current.db.createOrder(inserted)
    let retrieved = try Current.db.getOrder(inserted.id).wait()

    XCTAssertEqual(inserted, retrieved)
    XCTAssertEqual(inserted.addressName, retrieved.addressName)
  }

  func testInsertingAndRetrievingOrderNonNulls() throws {
    let inserted: Order = .empty
    inserted.printJobId = 55
    inserted.addressStreet2 = "Apt #2"

    _ = try Current.db.createOrder(inserted)
    let retrieved = try Current.db.getOrder(inserted.id).wait()

    XCTAssertEqual(inserted, retrieved)
    XCTAssertEqual(inserted.printJobId, retrieved.printJobId)
    XCTAssertEqual(inserted.addressStreet2, retrieved.addressStreet2)
  }

  func testGetOrdersByPrintJobStatus() throws {
    _ = try Current.db.deleteAllOrders().wait()

    let order1 = Order.empty
    order1.printJobStatus = .accepted
    let order2 = Order.empty
    order2.printJobStatus = .pending
    _ = try Current.db.createOrder(order1).wait()
    _ = try Current.db.createOrder(order2).wait()

    let found = try Current.db.getOrdersByPrintJobStatus(.accepted).wait()

    XCTAssertEqual(found.count, 1)
    XCTAssertEqual(found.first, order1)
  }

  func testUpdateOrder() throws {
    let order = Order.empty
    _ = try Current.db.createOrder(order).wait()

    let input = UpdateOrderInput(id: order.id.rawValue, printJobStatus: .bricked, printJobId: 55)
    let updated = try Current.db.updateOrder(input).wait()

    XCTAssertEqual(updated.printJobId, 55)
    XCTAssertEqual(updated.printJobStatus, .bricked)
  }

  func testUpdateOrderOnlyPrintJobId() throws {
    let order = Order.empty
    _ = try Current.db.createOrder(order).wait()

    let input = UpdateOrderInput(id: order.id.rawValue, printJobStatus: nil, printJobId: 66)
    let updated = try Current.db.updateOrder(input).wait()

    XCTAssertEqual(updated.printJobId, 66)
    XCTAssertEqual(updated.printJobStatus, order.printJobStatus)
  }

  func testUpdateOrderOnlyPrintJobStatus() throws {
    let order = Order.empty
    order.printJobId = 77
    _ = try Current.db.createOrder(order).wait()

    let input = UpdateOrderInput(id: order.id.rawValue, printJobStatus: .canceled, printJobId: nil)
    let updated = try Current.db.updateOrder(input).wait()

    XCTAssertEqual(updated.printJobId, 77)
    XCTAssertEqual(updated.printJobStatus, .canceled)
  }

  func testUpdateOrderBothNil() throws {
    let order = Order.empty
    order.printJobId = 88
    order.printJobStatus = .rejected
    _ = try Current.db.createOrder(order).wait()

    let input = UpdateOrderInput(id: order.id.rawValue, printJobStatus: nil, printJobId: nil)
    let updated = try Current.db.updateOrder(input).wait()

    XCTAssertEqual(updated.printJobId, 88)
    XCTAssertEqual(updated.printJobStatus, .rejected)
  }
}
