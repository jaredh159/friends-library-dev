// auto-generated, do not edit
import Graphiti
import Vapor

extension Order {
  enum GraphQL {
    enum Schema {
      enum Queries {}
      enum Mutations {}
    }
    enum Request {}
  }
}

extension Order.GraphQL.Schema {
  static var type: AppType<Order> {
    Type(Order.self) {
      Field("id", at: \.id.rawValue)
      Field("lang", at: \.lang)
      Field("source", at: \.source)
      Field("paymentId", at: \.paymentId.rawValue)
      Field("printJobId", at: \.printJobId?.rawValue)
      Field("printJobStatus", at: \.printJobStatus)
      Field("amount", at: \.amount.rawValue)
      Field("taxes", at: \.taxes.rawValue)
      Field("ccFeeOffset", at: \.ccFeeOffset.rawValue)
      Field("shipping", at: \.shipping.rawValue)
      Field("shippingLevel", at: \.shippingLevel)
      Field("email", at: \.email.rawValue)
      Field("addressName", at: \.addressName)
      Field("addressStreet", at: \.addressStreet)
      Field("addressStreet2", at: \.addressStreet2)
      Field("addressCity", at: \.addressCity)
      Field("addressState", at: \.addressState)
      Field("addressZip", at: \.addressZip)
      Field("addressCountry", at: \.addressCountry)
      Field("freeOrderRequestId", at: \.freeOrderRequestId?.rawValue)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
    }
  }
}

extension Order.GraphQL.Request {
  struct CreateOrderInput: Codable {
    let id: UUID?
    let lang: Lang
    let source: Order.OrderSource
    let paymentId: String
    let printJobId: Int?
    let printJobStatus: Order.PrintJobStatus
    let amount: Int
    let taxes: Int
    let ccFeeOffset: Int
    let shipping: Int
    let shippingLevel: Order.ShippingLevel
    let email: String
    let addressName: String
    let addressStreet: String
    let addressStreet2: String?
    let addressCity: String
    let addressState: String
    let addressZip: String
    let addressCountry: String
    let freeOrderRequestId: UUID?
  }

  struct UpdateOrderInput: Codable {
    let id: UUID
    let lang: Lang
    let source: Order.OrderSource
    let paymentId: String
    let printJobId: Int?
    let printJobStatus: Order.PrintJobStatus
    let amount: Int
    let taxes: Int
    let ccFeeOffset: Int
    let shipping: Int
    let shippingLevel: Order.ShippingLevel
    let email: String
    let addressName: String
    let addressStreet: String
    let addressStreet2: String?
    let addressCity: String
    let addressState: String
    let addressZip: String
    let addressCountry: String
    let freeOrderRequestId: UUID?
  }
}

extension Order.GraphQL.Request {
  struct CreateOrderArgs: Codable {
    let input: Order.GraphQL.Request.CreateOrderInput
  }

  struct UpdateOrderArgs: Codable {
    let input: Order.GraphQL.Request.UpdateOrderInput
  }

  struct CreateOrdersArgs: Codable {
    let input: [Order.GraphQL.Request.CreateOrderInput]
  }

  struct UpdateOrdersArgs: Codable {
    let input: [Order.GraphQL.Request.UpdateOrderInput]
  }
}

extension Order.GraphQL.Schema {
  static var create: AppInput<Order.GraphQL.Request.CreateOrderInput> {
    Input(Order.GraphQL.Request.CreateOrderInput.self) {
      InputField("id", at: \.id)
      InputField("lang", at: \.lang)
      InputField("source", at: \.source)
      InputField("paymentId", at: \.paymentId)
      InputField("printJobId", at: \.printJobId)
      InputField("printJobStatus", at: \.printJobStatus)
      InputField("amount", at: \.amount)
      InputField("taxes", at: \.taxes)
      InputField("ccFeeOffset", at: \.ccFeeOffset)
      InputField("shipping", at: \.shipping)
      InputField("shippingLevel", at: \.shippingLevel)
      InputField("email", at: \.email)
      InputField("addressName", at: \.addressName)
      InputField("addressStreet", at: \.addressStreet)
      InputField("addressStreet2", at: \.addressStreet2)
      InputField("addressCity", at: \.addressCity)
      InputField("addressState", at: \.addressState)
      InputField("addressZip", at: \.addressZip)
      InputField("addressCountry", at: \.addressCountry)
      InputField("freeOrderRequestId", at: \.freeOrderRequestId)
    }
  }

  static var update: AppInput<Order.GraphQL.Request.UpdateOrderInput> {
    Input(Order.GraphQL.Request.UpdateOrderInput.self) {
      InputField("id", at: \.id)
      InputField("lang", at: \.lang)
      InputField("source", at: \.source)
      InputField("paymentId", at: \.paymentId)
      InputField("printJobId", at: \.printJobId)
      InputField("printJobStatus", at: \.printJobStatus)
      InputField("amount", at: \.amount)
      InputField("taxes", at: \.taxes)
      InputField("ccFeeOffset", at: \.ccFeeOffset)
      InputField("shipping", at: \.shipping)
      InputField("shippingLevel", at: \.shippingLevel)
      InputField("email", at: \.email)
      InputField("addressName", at: \.addressName)
      InputField("addressStreet", at: \.addressStreet)
      InputField("addressStreet2", at: \.addressStreet2)
      InputField("addressCity", at: \.addressCity)
      InputField("addressState", at: \.addressState)
      InputField("addressZip", at: \.addressZip)
      InputField("addressCountry", at: \.addressCountry)
      InputField("freeOrderRequestId", at: \.freeOrderRequestId)
    }
  }
}

extension Order.GraphQL.Schema.Queries {
  static var get: AppField<Order, IdentifyEntityArgs> {
    Field("getOrder", at: Resolver.getOrder) {
      Argument("id", at: \.id)
    }
  }

  static var list: AppField<[Order], NoArgs> {
    Field("getOrders", at: Resolver.getOrders)
  }
}

extension Order.GraphQL.Schema.Mutations {
  static var create: AppField<Order, Order.GraphQL.Request.CreateOrderArgs> {
    Field("createOrder", at: Resolver.createOrder) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[Order], Order.GraphQL.Request.CreateOrdersArgs> {
    Field("createOrder", at: Resolver.createOrders) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<Order, Order.GraphQL.Request.UpdateOrderArgs> {
    Field("createOrder", at: Resolver.updateOrder) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[Order], Order.GraphQL.Request.UpdateOrdersArgs> {
    Field("createOrder", at: Resolver.updateOrders) {
      Argument("input", at: \.input)
    }
  }

  static var delete: AppField<Order, IdentifyEntityArgs> {
    Field("deleteOrder", at: Resolver.deleteOrder) {
      Argument("id", at: \.id)
    }
  }
}

extension Order {
  convenience init(_ input: Order.GraphQL.Request.CreateOrderInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      printJobId: input.printJobId != nil ? .init(rawValue: input.printJobId!) : nil,
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
      addressCountry: input.addressCountry,
      freeOrderRequestId: input.freeOrderRequestId != nil ? .init(rawValue: input.freeOrderRequestId!) : nil
    )
  }

  func update(_ input: Order.GraphQL.Request.UpdateOrderInput) {
    self.lang = input.lang
    self.source = input.source
    self.paymentId = .init(rawValue: input.paymentId)
    self.printJobId = input.printJobId != nil ? .init(rawValue: input.printJobId!) : nil
    self.printJobStatus = input.printJobStatus
    self.amount = .init(rawValue: input.amount)
    self.taxes = .init(rawValue: input.taxes)
    self.ccFeeOffset = .init(rawValue: input.ccFeeOffset)
    self.shipping = .init(rawValue: input.shipping)
    self.shippingLevel = input.shippingLevel
    self.email = .init(rawValue: input.email)
    self.addressName = input.addressName
    self.addressStreet = input.addressStreet
    self.addressStreet2 = input.addressStreet2
    self.addressCity = input.addressCity
    self.addressState = input.addressState
    self.addressZip = input.addressZip
    self.addressCountry = input.addressCountry
    self.freeOrderRequestId = input.freeOrderRequestId != nil ? .init(rawValue: input.freeOrderRequestId!) : nil
    self.updatedAt = Current.date()
  }
}
