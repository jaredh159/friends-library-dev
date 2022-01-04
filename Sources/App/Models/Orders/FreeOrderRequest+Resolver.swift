import Fluent
import Foundation
import Graphiti
import Vapor
import VaporUtils

extension Resolver {

  func getFreeOrderRequest(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<FreeOrderRequest> {
    try req.requirePermission(to: .queryOrders)
    return future(of: FreeOrderRequest.self, on: req.eventLoop) {
      try await Current.db.getFreeOrderRequest(.init(rawValue: args.id))
    }
  }

  func createFreeOrderRequest(
    req: Req,
    args: AppSchema.CreateFreeOrderRequestArgs
  ) throws -> Future<FreeOrderRequest> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: FreeOrderRequest.self, on: req.eventLoop) {
      let order = try await Current.db.createFreeOrderRequest(FreeOrderRequest(args.input))
      try await sendFreeOrderRequestNotifications(for: order, on: req).get()
      return order
    }
  }
}

private func sendFreeOrderRequestNotifications(
  for order: FreeOrderRequest,
  on request: Request
) -> Future<Void> {
  let id = order.id.rawValue.uuidString.lowercased()
  var emailFuture = request.eventLoop.makeSucceededVoidFuture()
  if let emailTo = Env.get("FREE_ORDER_REQUEST_EMAIL_RECIPIENT") {
    emailFuture = SendGridEmail(
      to: .init(email: emailTo),
      from: .init(
        email: "notifications@graphql-api.friendslibrary.com",
        name: "Friends Library"
      ),
      subject: "[,] Free Book Request - \(id)",
      html:
        """
        \(entry("Name", order.name))
        \(entry("Email", order.email.rawValue))
        \(entry("Requested Books", order.requestedBooks))
        \(entry("About Requester", order.aboutRequester))
        \(entry("Street", order.addressStreet))
        \(entry("Street 2", order.addressStreet2))
        \(entry("City", order.addressCity))
        \(entry("State", order.addressState))
        \(entry("Zip", order.addressZip))
        \(entry("Country", order.addressCountry))
        \(entry("Source", order.source))

        <br />
        <br />

        <a href="https://orders.friendslibrary.com?request=\(id)">
          Create Order &raquo;
        </a>
        """
    )
    .send(on: request.client, withKey: Env.SENDGRID_API_KEY)
    .transform(to: ())
  }

  var slackFuture = request.eventLoop.makeSucceededVoidFuture()
  if request.application.environment == .production {
    slackFuture = SlackMessage(
      text:
        "New *Spanish Free Book Order Request:*\n  → _Name_ `\(order.name)`\n  → _Books_ `\(order.requestedBooks)`\n  → _About_ `\(order.aboutRequester.replacingOccurrences(of: "\n", with: ""))`",
      channel: "orders",
      username: "FLP Api Bot",
      emoji: .custom("orange_book")
    )
    .send(on: request.client, withToken: Env.SLACK_API_TOKEN)
    .transform(to: ())
  }

  return [emailFuture, slackFuture].flatten(on: request.eventLoop)
}

private func entry(_ key: String, _ value: String?) -> String {
  guard let value = value else {
    return ""
  }
  return
    """
    <p>
      <b>\(key):</b>&nbsp;
      \(value.replacingOccurrences(of: "\n", with: "<br />"))
    </p>
    """
}

// below auto-generated

extension Resolver {

  func getFreeOrderRequests(
    req: Req,
    args: NoArgs
  ) throws -> Future<[FreeOrderRequest]> {
    throw Abort(.notImplemented)
  }

  func createFreeOrderRequests(
    req: Req,
    args: AppSchema.CreateFreeOrderRequestsArgs
  ) throws -> Future<[FreeOrderRequest]> {
    throw Abort(.notImplemented)
  }

  func updateFreeOrderRequest(
    req: Req,
    args: AppSchema.UpdateFreeOrderRequestArgs
  ) throws -> Future<FreeOrderRequest> {
    throw Abort(.notImplemented)
  }

  func updateFreeOrderRequests(
    req: Req,
    args: AppSchema.UpdateFreeOrderRequestsArgs
  ) throws -> Future<[FreeOrderRequest]> {
    throw Abort(.notImplemented)
  }

  func deleteFreeOrderRequest(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<FreeOrderRequest> {
    throw Abort(.notImplemented)
  }
}
