import Graphiti
import Vapor
import XSlack

extension Resolver {
  func sendOrderConfirmationEmail(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<GenericResponse> {
    future(of: GenericResponse.self, on: req.eventLoop) {
      let order = try await Current.db.find(Order.self, byId: args.id)
      let email = try await EmailBuilder.orderConfirmation(order)
      try await Current.sendGridClient.send(email)

      let linkText = Slack.Message.link(
        to: "https://admin.friendslibrary.com/orders/\(order.id.lowercased)",
        withText: "Click here for details"
      )
      await slackOrder("*Order submitted* \(linkText).")

      return .init(success: true)
    }
  }
}

extension AppSchema {
  static var sendOrderConfirmationEmail: AppField<GenericResponse, IdentifyEntityArgs> {
    Field("sendOrderConfirmationEmail", at: Resolver.sendOrderConfirmationEmail) {
      Argument("id", at: \.id)
    }
  }
}
