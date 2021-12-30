// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension FriendQuote {
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

extension FriendQuote.GraphQL.Schema {
  static var type: AppType<FriendQuote> {
    Type(FriendQuote.self) {
      Field("id", at: \.id.rawValue)
      Field("friendId", at: \.friendId.rawValue)
      Field("source", at: \.source)
      Field("order", at: \.order)
      Field("context", at: \.context)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
    }
  }
}

extension FriendQuote.GraphQL.Request.Inputs {
  struct Create: Codable {
    let id: UUID?
    let friendId: UUID
    let source: String
    let order: Int
    let context: String?
  }

  struct Update: Codable {
    let id: UUID
    let friendId: UUID
    let source: String
    let order: Int
    let context: String?
  }
}

extension FriendQuote.GraphQL.Request.Args {
  struct Create: Codable {
    let input: FriendQuote.GraphQL.Request.Inputs.Create
  }

  struct Update: Codable {
    let input: FriendQuote.GraphQL.Request.Inputs.Update
  }

  struct UpdateMany: Codable {
    let input: [FriendQuote.GraphQL.Request.Inputs.Update]
  }

  struct CreateMany: Codable {
    let input: [FriendQuote.GraphQL.Request.Inputs.Create]
  }
}

extension FriendQuote.GraphQL.Schema.Inputs {
  static var create: AppInput<FriendQuote.GraphQL.Request.Inputs.Create> {
    Input(FriendQuote.GraphQL.Request.Inputs.Create.self) {
      InputField("id", at: \.id)
      InputField("friendId", at: \.friendId)
      InputField("source", at: \.source)
      InputField("order", at: \.order)
      InputField("context", at: \.context)
    }
  }

  static var update: AppInput<FriendQuote.GraphQL.Request.Inputs.Update> {
    Input(FriendQuote.GraphQL.Request.Inputs.Update.self) {
      InputField("id", at: \.id)
      InputField("friendId", at: \.friendId)
      InputField("source", at: \.source)
      InputField("order", at: \.order)
      InputField("context", at: \.context)
    }
  }
}

extension FriendQuote.GraphQL.Schema.Queries {
  static var get: AppField<FriendQuote, IdentifyEntityArgs> {
    Field("getFriendQuote", at: Resolver.getFriendQuote) {
      Argument("id", at: \.id)
    }
  }

  static var list: AppField<[FriendQuote], NoArgs> {
    Field("getFriendQuotes", at: Resolver.getFriendQuotes)
  }
}

extension FriendQuote.GraphQL.Schema.Mutations {
  static var create: AppField<FriendQuote, FriendQuote.GraphQL.Request.Args.Create> {
    Field("createFriendQuote", at: Resolver.createFriendQuote) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[FriendQuote], FriendQuote.GraphQL.Request.Args.CreateMany> {
    Field("createFriendQuote", at: Resolver.createFriendQuotes) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<FriendQuote, FriendQuote.GraphQL.Request.Args.Update> {
    Field("createFriendQuote", at: Resolver.updateFriendQuote) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[FriendQuote], FriendQuote.GraphQL.Request.Args.UpdateMany> {
    Field("createFriendQuote", at: Resolver.updateFriendQuotes) {
      Argument("input", at: \.input)
    }
  }

  static var delete: AppField<FriendQuote, IdentifyEntityArgs> {
    Field("deleteFriendQuote", at: Resolver.deleteFriendQuote) {
      Argument("id", at: \.id)
    }
  }
}

extension FriendQuote {
  convenience init(_ input: FriendQuote.GraphQL.Request.Inputs.Create) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      friendId: .init(rawValue: input.friendId),
      source: input.source,
      order: input.order,
      context: input.context
    )
  }

  func update(_ input: FriendQuote.GraphQL.Request.Inputs.Update) throws {
    self.friendId = .init(rawValue: input.friendId)
    self.source = input.source
    self.order = input.order
    self.context = input.context
    self.updatedAt = Current.date()
  }
}
