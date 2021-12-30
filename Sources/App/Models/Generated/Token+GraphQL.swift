// auto-generated, do not edit
import Graphiti
import Vapor

extension Token {
  enum GraphQL {
    enum Schema {
      enum Queries {}
      enum Mutations {}
    }
    enum Request {}
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

extension Token.GraphQL.Request {
  struct CreateTokenInput: Codable {
    let id: UUID?
    let value: UUID
    let description: String
  }

  struct UpdateTokenInput: Codable {
    let id: UUID
    let value: UUID
    let description: String
  }
}

extension Token.GraphQL.Request {
  struct CreateTokenArgs: Codable {
    let input: Token.GraphQL.Request.CreateTokenInput
  }

  struct UpdateTokenArgs: Codable {
    let input: Token.GraphQL.Request.UpdateTokenInput
  }

  struct CreateTokensArgs: Codable {
    let input: [Token.GraphQL.Request.CreateTokenInput]
  }

  struct UpdateTokensArgs: Codable {
    let input: [Token.GraphQL.Request.UpdateTokenInput]
  }
}

extension Token.GraphQL.Schema {
  static var create: AppInput<Token.GraphQL.Request.CreateTokenInput> {
    Input(Token.GraphQL.Request.CreateTokenInput.self) {
      InputField("id", at: \.id)
      InputField("value", at: \.value)
      InputField("description", at: \.description)
    }
  }

  static var update: AppInput<Token.GraphQL.Request.UpdateTokenInput> {
    Input(Token.GraphQL.Request.UpdateTokenInput.self) {
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
  static var create: AppField<Token, Token.GraphQL.Request.CreateTokenArgs> {
    Field("createToken", at: Resolver.createToken) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[Token], Token.GraphQL.Request.CreateTokensArgs> {
    Field("createToken", at: Resolver.createTokens) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<Token, Token.GraphQL.Request.UpdateTokenArgs> {
    Field("createToken", at: Resolver.updateToken) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[Token], Token.GraphQL.Request.UpdateTokensArgs> {
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
  convenience init(_ input: Token.GraphQL.Request.CreateTokenInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      value: .init(rawValue: input.value),
      description: input.description
    )
  }

  func update(_ input: Token.GraphQL.Request.UpdateTokenInput) {
    self.value = .init(rawValue: input.value)
    self.description = input.description
  }
}
