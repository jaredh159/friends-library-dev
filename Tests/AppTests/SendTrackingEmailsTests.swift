import Foundation
import XCTest

@testable import App

final class SendTrackingEmailsTests: AppTestCase {
  var slacksSent: [Slack.Message] = []
  var sentEmails: [SendGrid.Email] = []
  var order = Order.mock

  override func setUp() {
    slacksSent = []
    sentEmails = []
    Current.slackClient.send = { [self] in self.slacksSent.append($0) }
    Current.sendGridClient.send = { [self] in self.sentEmails.append($0) }
    order = Order.mock
    order.email = "foo@bar.com"
    order.printJobStatus = .accepted
    order.printJobId = 33
  }

  func testCheckSendTrackingEmailsHappyPath() async throws {
    _ = try await Current.db.query(Order.self).delete()
    try await Current.db.create(order)

    Current.luluClient.listPrintJobs = { ids in
      XCTAssertEqual(ids, .init(33))
      return [.init(
        id: 33,
        status: .init(name: .shipped),
        lineItems: [.init(trackingUrls: ["/track/me"])]
      )]
    }

    await OrderPrintJobCoordinator.sendTrackingEmails()

    let retrieved = try await Current.db.find(order.id)
    XCTAssertEqual(retrieved.printJobStatus, .shipped)
    XCTAssertEqual(sentEmails.count, 1)
    XCTAssertEqual(sentEmails.first?.firstRecipient.email, "foo@bar.com")
    XCTAssert(sentEmails.first?.html.contains("/track/me") == true)
    XCTAssertEqual(slacksSent, [.order("Order \(order.id.lowercased) shipped")])
  }

  func testOrderCanceledUpdatesOrderAndSlacks() async throws {
    _ = try await Current.db.query(Order.self).delete()
    try await Current.db.create(order)

    Current.luluClient.listPrintJobs = { _ in
      [.init(id: 33, status: .init(name: .canceled), lineItems: [])]
    }

    await OrderPrintJobCoordinator.sendTrackingEmails()

    let retrieved = try await Current.db.find(order.id)
    XCTAssertEqual(retrieved.printJobStatus, .canceled)
    XCTAssertEqual(sentEmails.count, 0)
    XCTAssertEqual(slacksSent, [.error("order \(order.id) was CANCELED!")])
  }
}
