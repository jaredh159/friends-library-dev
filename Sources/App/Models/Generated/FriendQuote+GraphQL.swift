// auto-generated, do not edit
import Graphiti
import Vapor

extension FriendQuote {
  enum GraphQL {
    enum Schema {
      enum Queries {}
      enum Mutations {}
    }
    enum Request {}
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

extension FriendQuote.GraphQL.Request {
  struct CreateFriendQuoteInput: Codable {
    let id: UUID?
    let friendId: UUID
    let source: String
    let order: Int
    let context: String?
  }

  struct UpdateFriendQuoteInput: Codable {
    let id: UUID
    let friendId: UUID
    let source: String
    let order: Int
    let context: String?
  }
}

extension FriendQuote.GraphQL.Request {
  struct CreateFriendQuoteArgs: Codable {
    let input: FriendQuote.GraphQL.Request.CreateFriendQuoteInput
  }

  struct UpdateFriendQuoteArgs: Codable {
    let input: FriendQuote.GraphQL.Request.UpdateFriendQuoteInput
  }

  struct CreateFriendQuotesArgs: Codable {
    let input: [FriendQuote.GraphQL.Request.CreateFriendQuoteInput]
  }

  struct UpdateFriendQuotesArgs: Codable {
    let input: [FriendQuote.GraphQL.Request.UpdateFriendQuoteInput]
  }
}

extension FriendQuote.GraphQL.Schema {
  static var create: AppInput<FriendQuote.GraphQL.Request.CreateFriendQuoteInput> {
    Input(FriendQuote.GraphQL.Request.CreateFriendQuoteInput.self) {
      InputField("id", at: \.id)
      InputField("friendId", at: \.friendId)
      InputField("source", at: \.source)
      InputField("order", at: \.order)
      InputField("context", at: \.context)
    }
  }

  static var update: AppInput<FriendQuote.GraphQL.Request.UpdateFriendQuoteInput> {
    Input(FriendQuote.GraphQL.Request.UpdateFriendQuoteInput.self) {
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
  static var create: AppField<FriendQuote, FriendQuote.GraphQL.Request.CreateFriendQuoteArgs> {
    Field("createFriendQuote", at: Resolver.createFriendQuote) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[FriendQuote], FriendQuote.GraphQL.Request.CreateFriendQuotesArgs> {
    Field("createFriendQuote", at: Resolver.createFriendQuotes) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<FriendQuote, FriendQuote.GraphQL.Request.UpdateFriendQuoteArgs> {
    Field("createFriendQuote", at: Resolver.updateFriendQuote) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[FriendQuote], FriendQuote.GraphQL.Request.UpdateFriendQuotesArgs> {
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
  convenience init(_ input: FriendQuote.GraphQL.Request.CreateFriendQuoteInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      friendId: .init(rawValue: input.friendId),
      source: input.source,
      order: input.order,
      context: input.context
    )
  }

  func update(_ input: FriendQuote.GraphQL.Request.UpdateFriendQuoteInput) {
    self.friendId = .init(rawValue: input.friendId)
    self.source = input.source
    self.order = input.order
    self.context = input.context
    self.updatedAt = Current.date()
  }
}
