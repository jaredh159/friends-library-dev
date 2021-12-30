// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension TokenScope {
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

extension TokenScope.GraphQL.Schema {
  static var type: AppType<TokenScope> {
    Type(TokenScope.self) {
      Field("id", at: \.id.rawValue)
      Field("scope", at: \.scope)
      Field("tokenId", at: \.tokenId.rawValue)
      Field("createdAt", at: \.createdAt)
    }
  }
}

extension TokenScope.GraphQL.Request.Inputs {
  struct Create: Codable {
    let id: UUID?
    let scope: Scope
    let tokenId: UUID
  }

  struct Update: Codable {
    let id: UUID
    let scope: Scope
    let tokenId: UUID
  }
}

extension TokenScope.GraphQL.Request.Args {
  struct Create: Codable {
    let input: TokenScope.GraphQL.Request.Inputs.Create
  }

  struct Update: Codable {
    let input: TokenScope.GraphQL.Request.Inputs.Update
  }

  struct UpdateMany: Codable {
    let input: [TokenScope.GraphQL.Request.Inputs.Update]
  }

  struct CreateMany: Codable {
    let input: [TokenScope.GraphQL.Request.Inputs.Create]
  }
}

extension TokenScope.GraphQL.Schema.Inputs {
  static var create: AppInput<TokenScope.GraphQL.Request.Inputs.Create> {
    Input(TokenScope.GraphQL.Request.Inputs.Create.self) {
      InputField("id", at: \.id)
      InputField("scope", at: \.scope)
      InputField("tokenId", at: \.tokenId)
    }
  }

  static var update: AppInput<TokenScope.GraphQL.Request.Inputs.Update> {
    Input(TokenScope.GraphQL.Request.Inputs.Update.self) {
      InputField("id", at: \.id)
      InputField("scope", at: \.scope)
      InputField("tokenId", at: \.tokenId)
    }
  }
}

extension TokenScope.GraphQL.Schema.Queries {
  static var get: AppField<TokenScope, IdentifyEntityArgs> {
    Field("getTokenScope", at: Resolver.getTokenScope) {
      Argument("id", at: \.id)
    }
  }

  static var list: AppField<[TokenScope], NoArgs> {
    Field("getTokenScopes", at: Resolver.getTokenScopes)
  }
}

extension TokenScope.GraphQL.Schema.Mutations {
  static var create: AppField<TokenScope, TokenScope.GraphQL.Request.Args.Create> {
    Field("createTokenScope", at: Resolver.createTokenScope) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[TokenScope], TokenScope.GraphQL.Request.Args.CreateMany> {
    Field("createTokenScope", at: Resolver.createTokenScopes) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<TokenScope, TokenScope.GraphQL.Request.Args.Update> {
    Field("createTokenScope", at: Resolver.updateTokenScope) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[TokenScope], TokenScope.GraphQL.Request.Args.UpdateMany> {
    Field("createTokenScope", at: Resolver.updateTokenScopes) {
      Argument("input", at: \.input)
    }
  }

  static var delete: AppField<TokenScope, IdentifyEntityArgs> {
    Field("deleteTokenScope", at: Resolver.deleteTokenScope) {
      Argument("id", at: \.id)
    }
  }
}

extension TokenScope {
  convenience init(_ input: TokenScope.GraphQL.Request.Inputs.Create) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      tokenId: .init(rawValue: input.tokenId),
      scope: input.scope
    )
  }

  func update(_ input: TokenScope.GraphQL.Request.Inputs.Update) throws {
    self.scope = input.scope
    self.tokenId = .init(rawValue: input.tokenId)
  }
}
