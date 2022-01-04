import Vapor
import XCTest

@testable import App

final class OrderRepositoryTests: AppTestCase {

  func testInsertingAndRetrievingOrder() async throws {
    let inserted: Order = .empty
    inserted.addressName = "Bob"

    _ = try await Current.db.createOrderWithItems(inserted)
    let retrieved = try await Current.db.getOrder(inserted.id)

    XCTAssertEqual(inserted, retrieved)
    XCTAssertEqual(inserted.addressName, retrieved.addressName)
  }

  func testInsertingAndRetrievingOrderNonNulls() async throws {
    let inserted: Order = .empty
    inserted.printJobId = 55
    inserted.addressStreet2 = "Apt #2"

    _ = try await Current.db.createOrderWithItems(inserted)
    let retrieved = try await Current.db.getOrder(inserted.id)

    XCTAssertEqual(inserted, retrieved)
    XCTAssertEqual(inserted.printJobId, retrieved.printJobId)
    XCTAssertEqual(inserted.addressStreet2, retrieved.addressStreet2)
  }

  func testGetOrdersByPrintJobStatus() async throws {
    try await Current.db.deleteAllOrders()

    let order1 = Order.empty
    order1.printJobStatus = .accepted
    let order2 = Order.empty
    order2.printJobStatus = .pending
    _ = try await Current.db.createOrderWithItems(order1)
    _ = try await Current.db.createOrderWithItems(order2)

    let found = try await Current.db.getOrdersByPrintJobStatus(.accepted)

    XCTAssertEqual(found.count, 1)
    XCTAssertEqual(found.first, order1)
  }

  // func testUpdateOrder() async throws {
  //   let order = Order.empty
  //   try await Current.db.createOrderWithItems(order)

  //   let input = UpdateOrderInput(id: order.id.rawValue, printJobStatus: .bricked, printJobId: 55)
  //   let updated = try await Current.db.updateOrder(input)

  //   XCTAssertEqual(updated.printJobId, 55)
  //   XCTAssertEqual(updated.printJobStatus, .bricked)
  // }

  // func testUpdateOrderOnlyPrintJobId() async throws {
  //   let order = Order.empty
  //   try await Current.db.createOrderWithItems(order)

  //   let input = UpdateOrderInput(id: order.id.rawValue, printJobStatus: nil, printJobId: 66)
  //   let updated = try await Current.db.updateOrder(input)

  //   XCTAssertEqual(updated.printJobId, 66)
  //   XCTAssertEqual(updated.printJobStatus, order.printJobStatus)
  // }

  // func testUpdateOrderOnlyPrintJobStatus() async throws {
  //   let order = Order.empty
  //   order.printJobId = 77
  //   try await Current.db.createOrderWithItems(order)

  //   let input = UpdateOrderInput(id: order.id.rawValue, printJobStatus: .canceled, printJobId: nil)
  //   let updated = try await Current.db.updateOrder(input)

  //   XCTAssertEqual(updated.printJobId, 77)
  //   XCTAssertEqual(updated.printJobStatus, .canceled)
  // }

  // func testUpdateOrderBothNil() async throws {
  //   let order = Order.empty
  //   order.printJobId = 88
  //   order.printJobStatus = .rejected
  //   try await Current.db.createOrderWithItems(order)

  //   let input = UpdateOrderInput(id: order.id.rawValue, printJobStatus: nil, printJobId: nil)
  //   let updated = try await Current.db.updateOrder(input)

  //   XCTAssertEqual(updated.printJobId, 88)
  //   XCTAssertEqual(updated.printJobStatus, .rejected)
  // }
}
