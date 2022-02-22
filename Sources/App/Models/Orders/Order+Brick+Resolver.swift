import Graphiti
import Vapor

struct BrickOrderInput: Codable {
  let orderPaymentId: String?
  let orderId: String?
  let userAgent: String?
  let stateHistory: [String]?
}

extension AppSchema {
  static var BrickOrderInputType: AppInput<BrickOrderInput> {
    Input(BrickOrderInput.self) {
      InputField("orderId", at: \.orderId)
      InputField("orderPaymentId", at: \.orderPaymentId)
      InputField("userAgent", at: \.userAgent)
      InputField("stateHistory", at: \.stateHistory)
    }
  }

  static var brickOrder: AppField<GenericResponse, InputArgs<BrickOrderInput>> {
    Field("brickOrder", at: Resolver.brickOrder) {
      Argument("input", at: \.input)
    }
  }
}

extension Resolver {
  func brickOrder(
    req: Req,
    args: InputArgs<BrickOrderInput>
  ) throws -> Future<GenericResponse> {
    let forOrder = "for bricked order `\(args.input.orderId ?? "<no order id>")`"
    return future(of: GenericResponse.self, on: req.eventLoop) {
      if let paymentIntentId = args.input.orderPaymentId, !paymentIntentId.isEmpty {
        do {
          let refund = try await Current.stripeClient.createRefund(paymentIntentId)
          await slackError("Created stripe refund `\(refund.id)` \(forOrder)")
        } catch {
          await slackError("Error creating refund \(forOrder): `\(error)`")
        }
        do {
          let pi = try await Current.stripeClient.cancelPaymentIntent(paymentIntentId)
          await slackError("Canceled stripe payment intent `\(pi.id)` \(forOrder)")
        } catch {
          await slackError("Error cancelling payment intent (expected) \(forOrder): `\(error)`")
        }
      }
      if let rawId = args.input.orderId, let orderId = UUID(uuidString: rawId) {
        do {
          let order = try await Current.db.find(Order.Id(rawValue: orderId))
          order.printJobStatus = .bricked
          try await Current.db.update(order)
          await slackError("Updated order `\(rawId)` to printJobStatus `.bricked`")
        } catch {
          await slackError("Failed to update order `\(rawId)` to printJobStatus `.bricked`")
        }
      }

      await slackError("""
      *Bricked Order*
      ```
      \(JSON.encode(args.input, .pretty) ?? String(describing: args.input))
      ```
      """)
      return GenericResponse(success: true)
    }
  }
}
