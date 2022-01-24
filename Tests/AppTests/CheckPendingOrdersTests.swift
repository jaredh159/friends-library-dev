import Foundation
import Vapor
import XCTest

@testable import App

final class CheckPendingOrdersTests: AppTestCase {
  var slacksSent: [Slack.Message] = []

  override func setUp() {
    Current.slackClient.send = { [self] in self.slacksSent.append($0) }
    slacksSent = []
  }

  func testCheckPendingOrdersHappyPath() async throws {
    let order = Order.mock
    order.printJobStatus = .pending
    order.printJobId = 33
    _ = try await Current.db.query(Order.self).delete()
    try await Current.db.create(order)

    Current.luluClient.listPrintJobs = { ids in
      XCTAssertEqual(ids, .init(33))
      return [.init(
        id: 33,
        status: .init(name: .productionDelayed),
        lineItems: []
      )]
    }

    await OrderPrintJobCoordinator.checkPendingOrders()

    let retrieved = try await Current.db.find(order.id)
    XCTAssertEqual(retrieved.printJobStatus, .accepted)
    XCTAssertEqual(
      slacksSent,
      [.order("Verified acceptance of print job 33, status: PRODUCTION_DELAYED")]
    )
  }

  func testSlackLogsErrorIfDbThrows() async throws {
    let existingDb = Current.db
    Current.db = ThrowingDatabaseClient()
    await OrderPrintJobCoordinator.checkPendingOrders()
    XCTAssertEqual(
      slacksSent,
      [.error("Error querying orders & print jobs: Abort.501: ThrowingSql.select")]
    )
    Current.db = existingDb
  }

  func testSlackLogsErrorIfOrderMissingPrintJobId() async throws {
    _ = try await Current.db.query(Order.self).delete()
    let order = Order.mock
    order.printJobStatus = .pending
    order.printJobId = nil // <-- should never happen
    try await Current.db.create(order)

    await OrderPrintJobCoordinator.checkPendingOrders()

    XCTAssertEqual(
      slacksSent,
      [.error("Unexpected missing print job id in orders: [\(order.id)]")]
    )
  }

  func testRejectedPrintJobUpdatedAndSlacked() async throws {
    _ = try await Current.db.query(Order.self).delete()
    let order = Order.mock
    order.printJobStatus = .pending
    order.printJobId = 33
    try await Current.db.create(order)

    Current.luluClient.listPrintJobs = { _ in
      [
        .init(
          id: 33,
          status: .init(name: .rejected),
          lineItems: []
        ),
      ]
    }

    await OrderPrintJobCoordinator.checkPendingOrders()

    let retrieved = try await Current.db.find(order.id)
    XCTAssertEqual(retrieved.printJobStatus, .rejected)
    XCTAssertEqual(
      slacksSent,
      [.error("Print job 33 for order \(order.id) rejected")]
    )
  }
}

extension String: Error {}
