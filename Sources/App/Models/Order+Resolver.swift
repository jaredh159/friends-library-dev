import Fluent
import Foundation
import Graphiti
import Vapor

struct CreateOrderInput: Codable {
  struct Item: Codable {
    let title: String
    let documentId: UUID
    let editionType: EditionType
    let quantity: Int
    let unitPrice: Int
  }

  let paymentId: String
  let printJobStatus: Order.PrintJobStatus
  let printJobId: Int?
  let amount: Int
  let shipping: Int
  let taxes: Int
  let ccFeeOffset: Int
  let shippingLevel: Order.ShippingLevel
  let email: String
  let addressName: String
  let addressStreet: String
  let addressStreet2: String?
  let addressCity: String
  let addressState: String
  let addressZip: String
  let addressCountry: String
  let lang: Lang
  let source: Order.OrderSource
  let items: [Item]
}

extension Resolver {
  struct CreateOrderArgs: Codable {
    let order: CreateOrderInput
  }

  func createOrder(
    request: Request,
    args: CreateOrderArgs
  ) throws -> Future<Order> {
    let order = Order()
    order.paymentId = args.order.paymentId
    order.printJobStatus = args.order.printJobStatus
    order.printJobId = args.order.printJobId
    order.amount = args.order.amount
    order.shipping = args.order.shipping
    order.taxes = args.order.taxes
    order.ccFeeOffset = args.order.ccFeeOffset
    order.shippingLevel = args.order.shippingLevel
    order.email = args.order.email
    order.addressName = args.order.addressName
    order.addressStreet = args.order.addressStreet
    order.addressStreet2 = args.order.addressStreet2
    order.addressCity = args.order.addressCity
    order.addressState = args.order.addressState
    order.addressZip = args.order.addressZip
    order.addressCountry = args.order.addressCountry
    order.lang = args.order.lang
    order.source = args.order.source
    return order.create(on: request.db).flatMap { _ in
      let items = args.order.items.map { item -> OrderItem in
        let orderItem = OrderItem()
        orderItem.title = item.title
        orderItem.documentId = item.documentId
        orderItem.editionType = item.editionType
        orderItem.quantity = item.quantity
        orderItem.unitPrice = item.unitPrice
        return orderItem
      }
      return order.$items.create(items, on: request.db).map { order }
    }
  }

  func getOrder(
    request: Request,
    args: IdentifyEntityArgs
  ) throws -> Future<Order> {
    return Order.query(on: request.db)
      .with(\.$items)
      .filter(\.$id == args.id)
      .first()
      .unwrap(or: Abort(.notFound))
  }
}
