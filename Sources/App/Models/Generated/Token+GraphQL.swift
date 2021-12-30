// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension Token {
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

extension Token.GraphQL.Schema {
  static var type: AppType<Token> {
    Type(Token.self) {
      Field("id", at: \.id.rawValue)
      Field("value", at: \.value.rawValue)
      Field("description", at: \.description)
      Field("createdAt", at: \.createdAt)
    }
  }
}

extension Token.GraphQL.Request.Inputs {
  struct Create: Codable {
    let id: UUID?
    let value: UUID
    let description: String
  }

  struct Update: Codable {
    let id: UUID
    let value: UUID
    let description: String
  }
}

extension Token.GraphQL.Request.Args {
  struct Create: Codable {
    let input: Token.GraphQL.Request.Inputs.Create
  }

  struct Update: Codable {
    let input: Token.GraphQL.Request.Inputs.Update
  }

  struct UpdateMany: Codable {
    let input: [Token.GraphQL.Request.Inputs.Update]
  }

  struct CreateMany: Codable {
    let input: [Token.GraphQL.Request.Inputs.Create]
  }
}

extension Token.GraphQL.Schema.Inputs {
  static var create: AppInput<Token.GraphQL.Request.Inputs.Create> {
    Input(Token.GraphQL.Request.Inputs.Create.self) {
      InputField("id", at: \.id)
      InputField("value", at: \.value)
      InputField("description", at: \.description)
    }
  }

  static var update: AppInput<Token.GraphQL.Request.Inputs.Update> {
    Input(Token.GraphQL.Request.Inputs.Update.self) {
      InputField("id", at: \.id)
      InputField("value", at: \.value)
      InputField("description", at: \.description)
    }
  }
}

extension Token.GraphQL.Schema.Queries {
  static var get: AppField<Token, IdentifyEntityArgs> {
    Field("getToken", at: Resolver.getToken) {
      Argument("id", at: \.id)
    }
  }

  static var list: AppField<[Token], NoArgs> {
    Field("getTokens", at: Resolver.getTokens)
  }
}

extension Token.GraphQL.Schema.Mutations {
  static var create: AppField<Token, Token.GraphQL.Request.Args.Create> {
    Field("createToken", at: Resolver.createToken) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[Token], Token.GraphQL.Request.Args.CreateMany> {
    Field("createToken", at: Resolver.createTokens) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<Token, Token.GraphQL.Request.Args.Update> {
    Field("createToken", at: Resolver.updateToken) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[Token], Token.GraphQL.Request.Args.UpdateMany> {
    Field("createToken", at: Resolver.updateTokens) {
      Argument("input", at: \.input)
    }
  }

  static var delete: AppField<Token, IdentifyEntityArgs> {
    Field("deleteToken", at: Resolver.deleteToken) {
      Argument("id", at: \.id)
    }
  }
}

extension Token {
  convenience init(_ input: Token.GraphQL.Request.Inputs.Create) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      value: .init(rawValue: input.value),
      description: input.description
    )
  }

  func update(_ input: Token.GraphQL.Request.Inputs.Update) throws {
    self.value = .init(rawValue: input.value)
    self.description = input.description
  }
}
