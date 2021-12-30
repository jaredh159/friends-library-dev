// auto-generated, do not edit
import Graphiti
import Vapor

extension TokenScope {
  enum GraphQL {
    enum Schema {
      enum Queries {}
      enum Mutations {}
    }
    enum Request {}
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

extension TokenScope.GraphQL.Request {
  struct CreateTokenScopeInput: Codable {
    let id: UUID?
    let scope: Scope
    let tokenId: UUID
  }

  struct UpdateTokenScopeInput: Codable {
    let id: UUID
    let scope: Scope
    let tokenId: UUID
  }
}

extension TokenScope.GraphQL.Request {
  struct CreateTokenScopeArgs: Codable {
    let input: TokenScope.GraphQL.Request.CreateTokenScopeInput
  }

  struct UpdateTokenScopeArgs: Codable {
    let input: TokenScope.GraphQL.Request.UpdateTokenScopeInput
  }

  struct CreateTokenScopesArgs: Codable {
    let input: [TokenScope.GraphQL.Request.CreateTokenScopeInput]
  }

  struct UpdateTokenScopesArgs: Codable {
    let input: [TokenScope.GraphQL.Request.UpdateTokenScopeInput]
  }
}

extension TokenScope.GraphQL.Schema {
  static var create: AppInput<TokenScope.GraphQL.Request.CreateTokenScopeInput> {
    Input(TokenScope.GraphQL.Request.CreateTokenScopeInput.self) {
      InputField("id", at: \.id)
      InputField("scope", at: \.scope)
      InputField("tokenId", at: \.tokenId)
    }
  }

  static var update: AppInput<TokenScope.GraphQL.Request.UpdateTokenScopeInput> {
    Input(TokenScope.GraphQL.Request.UpdateTokenScopeInput.self) {
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
  static var create: AppField<TokenScope, TokenScope.GraphQL.Request.CreateTokenScopeArgs> {
    Field("createTokenScope", at: Resolver.createTokenScope) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[TokenScope], TokenScope.GraphQL.Request.CreateTokenScopesArgs> {
    Field("createTokenScope", at: Resolver.createTokenScopes) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<TokenScope, TokenScope.GraphQL.Request.UpdateTokenScopeArgs> {
    Field("createTokenScope", at: Resolver.updateTokenScope) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[TokenScope], TokenScope.GraphQL.Request.UpdateTokenScopesArgs> {
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
  convenience init(_ input: TokenScope.GraphQL.Request.CreateTokenScopeInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      tokenId: .init(rawValue: input.tokenId),
      scope: input.scope
    )
  }

  func update(_ input: TokenScope.GraphQL.Request.UpdateTokenScopeInput) {
    self.scope = input.scope
    self.tokenId = .init(rawValue: input.tokenId)
  }
}
