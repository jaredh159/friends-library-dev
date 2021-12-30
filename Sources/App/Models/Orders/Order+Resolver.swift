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

  // func createOrder(req: Req, args: CreateOrderArgs) throws -> Future<Order> {
  //   try req.requirePermission(to: .mutateOrders)
  //   let input = args.input
  //   let order = Order(
  //     id: .init(rawValue: input.id ?? UUID()),
  //     lang: input.lang,
  //     source: input.source,
  //     paymentId: .init(rawValue: input.paymentId),
  //     printJobStatus: input.printJobStatus,
  //     amount: .init(rawValue: input.amount),
  //     taxes: .init(rawValue: input.taxes),
  //     ccFeeOffset: .init(rawValue: input.ccFeeOffset),
  //     shipping: .init(rawValue: input.shipping),
  //     shippingLevel: input.shippingLevel,
  //     email: .init(rawValue: input.email),
  //     addressName: input.addressName,
  //     addressStreet: input.addressStreet,
  //     addressStreet2: input.addressStreet2,
  //     addressCity: input.addressCity,
  //     addressState: input.addressState,
  //     addressZip: input.addressZip,
  //     addressCountry: input.addressCountry
  //   )

  //   let items = input.items.map { item in
  //     OrderItem(
  //       orderId: order.id,
  //       documentId: .init(rawValue: item.documentId),
  //       editionType: item.editionType,
  //       title: item.title,
  //       quantity: item.quantity,
  //       unitPrice: .init(rawValue: item.unitPrice)
  //     )
  //   }

  //   order.items = .loaded(items)

  //   return future(of: Order.self, on: req.eventLoop) {
  //     try await Current.db.createOrderWithItems(order)
  //     return order
  //   }
  // }

  func getOrder(req: Req, args: IdentifyEntityArgs) throws -> Future<Order> {
    try req.requirePermission(to: .queryOrders)
    return future(of: Order.self, on: req.eventLoop) {
      try await Current.db.getOrder(.init(rawValue: args.id))
    }
  }

  struct GetOrdersArgs: Codable {
    let printJobStatus: Order.PrintJobStatus
  }

  func getOrders(req: Req, args: GetOrdersArgs) throws -> Future<[Order]> {
    try req.requirePermission(to: .queryOrders)
    return future(of: [Order].self, on: req.eventLoop) {
      try await Current.db.getOrdersByPrintJobStatus(args.printJobStatus)
    }
  }

  struct UpdateOrderArgs: Codable {
    let input: UpdateOrderInput
  }

  // func updateOrder(req: Req, args: UpdateOrderArgs) throws -> Future<Order> {
  //   try req.requirePermission(to: .mutateOrders)
  //   return future(of: Order.self, on: req.eventLoop) {
  //     try await Current.db.updateOrder(args.input)
  //   }
  // }

  struct UpdateOrdersArgs: Codable {
    let input: [UpdateOrderInput]
  }

  // func updateOrders(req: Req, args: UpdateOrdersArgs) throws -> Future<[Order]> {
  //   try req.requirePermission(to: .mutateOrders)
  //   return args.input.map { input in
  //     future(of: Order.self, on: req.eventLoop) {
  //       try await Current.db.updateOrder(input)
  //     }
  //   }
  //   .flatten(on: req.eventLoop)
  // }
}

// below auto-generated
extension Resolver {

  func getOrders(
    req: Req,
    args: NoArgs
  ) throws -> Future<[Order]> {
    throw Abort(.notImplemented)
  }

  func createOrder(
    req: Req,
    args: Order.GraphQL.Request.Args.Create
  ) throws -> Future<Order> {
    throw Abort(.notImplemented)
  }

  func createOrders(
    req: Req,
    args: Order.GraphQL.Request.Args.CreateMany
  ) throws -> Future<[Order]> {
    throw Abort(.notImplemented)
  }

  func updateOrder(
    req: Req,
    args: Order.GraphQL.Request.Args.Update
  ) throws -> Future<Order> {
    throw Abort(.notImplemented)
  }

  func updateOrders(
    req: Req,
    args: Order.GraphQL.Request.Args.UpdateMany
  ) throws -> Future<[Order]> {
    throw Abort(.notImplemented)
  }

  func deleteOrder(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<Order> {
    throw Abort(.notImplemented)
  }
}
