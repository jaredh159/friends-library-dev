import Fluent
import Foundation
import Graphiti
import TaggedMoney
import Vapor

struct UpdateOrderInput: Codable {
  let id: UUID
  let printJobStatus: Order.PrintJobStatus?
  let printJobId: Int?
}

struct CreateOrderInput: Codable {
  struct Item: Codable {
    let title: String
    let documentId: UUID
    let editionType: EditionType
    let quantity: Int
    let unitPrice: Int
  }

  let id: UUID?
  let freeOrderRequestId: UUID?
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
  let items: [CreateOrderInput.Item]
}

extension Resolver {
  struct CreateOrderArgs: Codable {
    let input: CreateOrderInput
  }

  func createOrder(req: Req, args: CreateOrderArgs) throws -> Future<Order> {
    try req.requirePermission(to: .mutateOrders)
    let input = args.input
    let order = Order(
      id: .init(rawValue: input.id ?? UUID()),
      lang: input.lang,
      source: input.source,
      paymentId: .init(rawValue: input.paymentId),
      printJobStatus: input.printJobStatus,
      amount: .init(rawValue: input.amount),
      taxes: .init(rawValue: input.taxes),
      ccFeeOffset: .init(rawValue: input.ccFeeOffset),
      shipping: .init(rawValue: input.shipping),
      shippingLevel: input.shippingLevel,
      email: .init(rawValue: input.email),
      addressName: input.addressName,
      addressStreet: input.addressStreet,
      addressStreet2: input.addressStreet2,
      addressCity: input.addressCity,
      addressState: input.addressState,
      addressZip: input.addressZip,
      addressCountry: input.addressCountry
    )
    throw Abort(.notImplemented)
    // let order = Order()
    // if let id = args.input.id {
    //   order.id = id
    // }
    // order.$freeOrderRequest.id = args.input.freeOrderRequestId
    // order.paymentId = args.input.paymentId
    // order.printJobStatus = args.input.printJobStatus
    // order.printJobId = args.input.printJobId
    // order.amount = args.input.amount
    // order.shipping = args.input.shipping
    // order.taxes = args.input.taxes
    // order.ccFeeOffset = args.input.ccFeeOffset
    // order.shippingLevel = args.input.shippingLevel
    // order.email = args.input.email
    // order.addressName = args.input.addressName
    // order.addressStreet = args.input.addressStreet
    // order.addressStreet2 = args.input.addressStreet2
    // order.addressCity = args.input.addressCity
    // order.addressState = args.input.addressState
    // order.addressZip = args.input.addressZip
    // order.addressCountry = args.input.addressCountry
    // order.lang = args.input.lang
    // order.source = args.input.source
    // return order.create(on: request.db).flatMap { _ in
    //   let items = args.input.items.map { item -> OrderItem in
    //     let orderItem = OrderItem()
    //     orderItem.title = item.title
    //     orderItem.documentId = item.documentId
    //     orderItem.editionType = item.editionType
    //     orderItem.quantity = item.quantity
    //     orderItem.unitPrice = item.unitPrice
    //     return orderItem
    //   }
    //   return order.$items.create(items, on: request.db).map { order }
    // }
  }

  func getOrder(req: Req, args: IdentifyEntityArgs) throws -> Future<Order> {
    try req.requirePermission(to: .queryOrders)
    return try Current.db.getOrder(.init(rawValue: args.id))
  }

  struct GetOrdersArgs: Codable {
    let printJobStatus: Order.PrintJobStatus
  }

  func getOrders(req: Req, args: GetOrdersArgs) throws -> Future<[Order]> {
    try req.requirePermission(to: .queryOrders)
    return try Current.db.getOrdersByPrintJobStatus(args.printJobStatus)
  }

  struct UpdateOrderArgs: Codable {
    let input: UpdateOrderInput
  }

  func updateOrder(req: Req, args: UpdateOrderArgs) throws -> Future<Order> {
    try req.requirePermission(to: .mutateOrders)
    return try Current.db.updateOrder(args.input)
  }

  struct UpdateOrdersArgs: Codable {
    let input: [UpdateOrderInput]
  }

  func updateOrders(req: Req, args: UpdateOrdersArgs) throws -> Future<[Order]> {
    try req.requirePermission(to: .mutateOrders)
    return try args.input.map { try Current.db.updateOrder($0) }
      .flatten(on: req.eventLoop)
  }
}
