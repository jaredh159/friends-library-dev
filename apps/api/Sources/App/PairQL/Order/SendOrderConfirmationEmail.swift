import PairQL
import XSlack

struct SendOrderConfirmationEmail: Pair {
  typealias Input = Order.Id
}

// resolver

extension SendOrderConfirmationEmail: PairQL.Resolver {
  static func resolve(with id: Input, in context: Context) async throws -> Output {
    let order = try await Order.find(id)
    let email = try await EmailBuilder.orderConfirmation(order)
    try await Current.sendGridClient.send(email)

    let link = Slack.Message.link(
      to: "https://admin.friendslibrary.com/orders/\(order.id.lowercased)",
      withText: "Click here for details"
    )

    await slackOrder("*Order submitted* \(link).")
    return .success
  }
}
