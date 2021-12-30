// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension OrderItem {
  enum GraphQL {
    enum Schema {
      enum Inputs {}
      enum Queries {}
      enum Mutations {}
    }
    enum Request {
      enum Inputs {}
      enum Args {}
    }
  }
}

extension OrderItem.GraphQL.Schema {
  static var type: AppType<OrderItem> {
    Type(OrderItem.self) {
      Field("id", at: \.id.rawValue)
      Field("orderId", at: \.orderId.rawValue)
      Field("documentId", at: \.documentId.rawValue)
      Field("editionType", at: \.editionType)
      Field("title", at: \.title)
      Field("quantity", at: \.quantity)
      Field("unitPrice", at: \.unitPrice.rawValue)
      Field("createdAt", at: \.createdAt)
    }
  }
}

extension OrderItem.GraphQL.Request.Inputs {
  struct Create: Codable {
    let id: UUID?
    let orderId: UUID
    let documentId: UUID
    let editionType: EditionType
    let title: String
    let quantity: Int
    let unitPrice: Int
  }

  struct Update: Codable {
    let id: UUID
    let orderId: UUID
    let documentId: UUID
    let editionType: EditionType
    let title: String
    let quantity: Int
    let unitPrice: Int
  }
}

extension OrderItem.GraphQL.Request.Args {
  struct Create: Codable {
    let input: OrderItem.GraphQL.Request.Inputs.Create
  }

  struct Update: Codable {
    let input: OrderItem.GraphQL.Request.Inputs.Update
  }

  struct UpdateMany: Codable {
    let input: [OrderItem.GraphQL.Request.Inputs.Update]
  }

  struct CreateMany: Codable {
    let input: [OrderItem.GraphQL.Request.Inputs.Create]
  }
}

extension OrderItem.GraphQL.Schema.Inputs {
  static var create: AppInput<OrderItem.GraphQL.Request.Inputs.Create> {
    Input(OrderItem.GraphQL.Request.Inputs.Create.self) {
      InputField("id", at: \.id)
      InputField("orderId", at: \.orderId)
      InputField("documentId", at: \.documentId)
      InputField("editionType", at: \.editionType)
      InputField("title", at: \.title)
      InputField("quantity", at: \.quantity)
      InputField("unitPrice", at: \.unitPrice)
    }
  }

  static var update: AppInput<OrderItem.GraphQL.Request.Inputs.Update> {
    Input(OrderItem.GraphQL.Request.Inputs.Update.self) {
      InputField("id", at: \.id)
      InputField("orderId", at: \.orderId)
      InputField("documentId", at: \.documentId)
      InputField("editionType", at: \.editionType)
      InputField("title", at: \.title)
      InputField("quantity", at: \.quantity)
      InputField("unitPrice", at: \.unitPrice)
    }
  }
}

extension OrderItem.GraphQL.Schema.Queries {
  static var get: AppField<OrderItem, IdentifyEntityArgs> {
    Field("getOrderItem", at: Resolver.getOrderItem) {
      Argument("id", at: \.id)
    }
  }

  static var list: AppField<[OrderItem], NoArgs> {
    Field("getOrderItems", at: Resolver.getOrderItems)
  }
}

extension OrderItem.GraphQL.Schema.Mutations {
  static var create: AppField<OrderItem, OrderItem.GraphQL.Request.Args.Create> {
    Field("createOrderItem", at: Resolver.createOrderItem) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[OrderItem], OrderItem.GraphQL.Request.Args.CreateMany> {
    Field("createOrderItem", at: Resolver.createOrderItems) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<OrderItem, OrderItem.GraphQL.Request.Args.Update> {
    Field("createOrderItem", at: Resolver.updateOrderItem) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[OrderItem], OrderItem.GraphQL.Request.Args.UpdateMany> {
    Field("createOrderItem", at: Resolver.updateOrderItems) {
      Argument("input", at: \.input)
    }
  }

  static var delete: AppField<OrderItem, IdentifyEntityArgs> {
    Field("deleteOrderItem", at: Resolver.deleteOrderItem) {
      Argument("id", at: \.id)
    }
  }
}

extension OrderItem {
  convenience init(_ input: OrderItem.GraphQL.Request.Inputs.Create) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      orderId: .init(rawValue: input.orderId),
      documentId: .init(rawValue: input.documentId),
      editionType: input.editionType,
      title: input.title,
      quantity: input.quantity,
      unitPrice: .init(rawValue: input.unitPrice)
    )
  }

  func update(_ input: OrderItem.GraphQL.Request.Inputs.Update) throws {
    self.orderId = .init(rawValue: input.orderId)
    self.documentId = .init(rawValue: input.documentId)
    self.editionType = input.editionType
    self.title = input.title
    self.quantity = input.quantity
    self.unitPrice = .init(rawValue: input.unitPrice)
  }
}
