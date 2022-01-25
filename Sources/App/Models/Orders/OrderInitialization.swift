import Foundation
import Graphiti
import TaggedMoney
import Vapor

struct OrderInitialization: Encodable {
  var orderId: Order.IdValue
  var orderPaymentId: Order.PaymentId
  var stripeClientSecret: String
  var createOrderToken: Token.Value
}

extension Resolver {
  func createOrderInitialization(
    req: Req,
    args: InputArgs<AppSchema.CreateOrderInitializationInput>
  ) throws -> Future<OrderInitialization> {
    let amount = Cents<Int>(rawValue: args.input.amount)
    let orderId = Order.Id()
    return future(of: OrderInitialization.self, on: req.eventLoop) {
      do {
        async let pi = Current.stripeClient.createPaymentIntent(amount, orderId)
        let tokenDesc = "single-use create order token for order \(orderId.lowercased)"
        async let token = Current.db.create(Token(description: tokenDesc, uses: 1))
        try await Current.db.create(TokenScope(tokenId: try await token.id, scope: .mutateOrders))
        return OrderInitialization(
          orderId: orderId,
          orderPaymentId: .init(rawValue: try await pi.id),
          stripeClientSecret: try await pi.clientSecret,
          createOrderToken: try await token.value
        )
      } catch {
        await Current.slackClient.send(.error("Error creating OrderInitialization: \(error)"))
        throw Abort(.internalServerError)
      }
    }
  }
}

extension AppSchema {
  struct CreateOrderInitializationInput: Codable {
    let amount: Int
  }

  static var createOrderInitialization: AppField<
    OrderInitialization,
    InputArgs<AppSchema.CreateOrderInitializationInput>
  > {
    Field("createOrderInitialization", at: Resolver.createOrderInitialization) {
      Argument("input", at: \.input)
    }
  }

  static var CreateOrderInitializationInputType: AppInput<CreateOrderInitializationInput> {
    Input(CreateOrderInitializationInput.self) {
      InputField("amount", at: \.amount)
    }
  }

  static var OrderInitializationType: AppType<OrderInitialization> {
    Type(OrderInitialization.self) {
      Field("orderId", at: \.orderId.rawValue.lowercased)
      Field("orderPaymentId", at: \.orderPaymentId.rawValue)
      Field("stripeClientSecret", at: \.stripeClientSecret)
      Field("createOrderToken", at: \.createOrderToken.rawValue.lowercased)
    }
  }
}
