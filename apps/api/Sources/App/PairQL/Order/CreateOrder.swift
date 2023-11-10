import DuetSQL
import PairQL
import TaggedMoney
import Vapor

struct CreateOrder: Pair {
  struct Input: PairInput {
    struct Item: PairNestable {
      let editionId: Edition.Id
      let quantity: Int
      let unitPrice: Cents<Int>
    }

    let id: Order.Id?
    let lang: Lang
    let source: Order.OrderSource
    let paymentId: Order.PaymentId
    let amount: Cents<Int>
    let taxes: Cents<Int>
    let fees: Cents<Int>
    let ccFeeOffset: Cents<Int>
    let shipping: Cents<Int>
    let shippingLevel: Order.ShippingLevel
    let email: EmailAddress
    let addressName: String
    let addressStreet: String
    let addressStreet2: String?
    let addressCity: String
    let addressState: String
    let addressZip: String
    let addressCountry: String
    let freeOrderRequestId: FreeOrderRequest.Id?
    let items: [Item]
  }

  typealias Output = Order.Id
}

// resolver

extension CreateOrder: PairQL.Resolver {
  static func resolve(with input: Input, in context: Context) async throws -> Output {
    let order = Order(input)
    let items = input.items.map { OrderItem($0, orderId: order.id) }
    order.items = .loaded(items)
    try await order.create()
    try await items.create()
    return order.id
  }
}

// authentication

extension CreateOrder {
  static func authenticate(with value: Token.Value) async throws {
    let token = try await Token.query().where(.value == value).first()
    let scopes = try await token.scopes()
    guard scopes.can(.mutateOrders) else {
      throw Abort(.unauthorized)
    }
    if let remaining = token.uses {
      if remaining < 2 {
        try await token.delete()
      } else {
        token.uses = remaining - 1
        try await token.save()
      }
    }
  }
}

extension Order {
  convenience init(_ input: CreateOrder.Input) {
    self.init(
      id: input.id ?? .init(),
      lang: input.lang,
      source: input.source,
      paymentId: input.paymentId,
      printJobStatus: .presubmit,
      amount: input.amount,
      taxes: input.taxes,
      fees: input.fees,
      ccFeeOffset: input.ccFeeOffset,
      shipping: input.shipping,
      shippingLevel: input.shippingLevel,
      email: input.email,
      addressName: input.addressName,
      addressStreet: input.addressStreet,
      addressStreet2: input.addressStreet2,
      addressCity: input.addressCity,
      addressState: input.addressState,
      addressZip: input.addressZip,
      addressCountry: input.addressCountry
    )
  }
}

extension OrderItem {
  convenience init(_ input: CreateOrder.Input.Item, orderId: Order.Id) {
    self.init(
      orderId: orderId,
      editionId: input.editionId,
      quantity: input.quantity,
      unitPrice: input.unitPrice
    )
  }
}
