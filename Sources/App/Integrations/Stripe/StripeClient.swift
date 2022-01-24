import Foundation
import TaggedMoney

extension Stripe {
  struct Client {
    var createPaymentIntent = createPaymentIntent(amount:orderId:)
    var cancelPaymentIntent = cancelPaymentIntent(id:)
    var createRefund = createRefund(paymentIntentId:)
  }
}

// implementation

private func createRefund(paymentIntentId: String) async throws -> Stripe.Api.Refund {
  try await HTTP.postFormUrlencoded(
    ["payment_intent": paymentIntentId],
    to: "https://api.stripe.com/v1/refunds",
    decoding: Stripe.Api.Refund.self,
    auth: .basic(Env.STRIPE_SECRET_KEY, ""),
    keyDecodingStrategy: .convertFromSnakeCase
  )
}

private func createPaymentIntent(
  amount: Cents<Int>,
  orderId: Order.IdValue
) async throws -> Stripe.Api.PaymentIntent {
  try await HTTP.postFormUrlencoded(
    [
      "amount": "\(amount.rawValue)",
      "currency": "USD",
      "metadata[orderId]": orderId.lowercased,
    ],
    to: "https://api.stripe.com/v1/payment_intents",
    decoding: Stripe.Api.PaymentIntent.self,
    auth: .basic(Env.STRIPE_SECRET_KEY, ""),
    keyDecodingStrategy: .convertFromSnakeCase
  )
}

private func cancelPaymentIntent(id: String) async throws -> Stripe.Api.PaymentIntent {
  try await HTTP.post(
    "https://api.stripe.com/v1/payment_intents/\(id)/cancel",
    decoding: Stripe.Api.PaymentIntent.self,
    auth: .basic(Env.STRIPE_SECRET_KEY, ""),
    keyDecodingStrategy: .convertFromSnakeCase
  )
}

// mock extension

extension Stripe.Client {
  static let mock = Stripe
    .Client(
      createPaymentIntent: { _, _ in
        .init(id: "pi_mock_id", clientSecret: "pi_mock_secret")
      },
      cancelPaymentIntent: { _ in
        .init(id: "pi_mock_id", clientSecret: "pi_mock_secret")
      },
      createRefund: { _ in
        .init(id: "re_mock_id")
      }
    )
}
