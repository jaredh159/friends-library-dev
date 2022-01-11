// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var TokenType: AppType<Token> {
    Type(Token.self) {
      Field("id", at: \.id.rawValue)
      Field("value", at: \.value.rawValue)
      Field("description", at: \.description)
      Field("createdAt", at: \.createdAt)
      Field("scopes", with: \.scopes)
    }
  }

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

  struct CreateTokenArgs: Codable {
    let input: AppSchema.CreateTokenInput
  }

  struct UpdateTokenArgs: Codable {
    let input: AppSchema.UpdateTokenInput
  }

  struct CreateTokensArgs: Codable {
    let input: [AppSchema.CreateTokenInput]
  }

  struct UpdateTokensArgs: Codable {
    let input: [AppSchema.UpdateTokenInput]
  }

  static var CreateTokenInputType: AppInput<AppSchema.CreateTokenInput> {
    Input(AppSchema.CreateTokenInput.self) {
      InputField("id", at: \.id)
      InputField("value", at: \.value)
      InputField("description", at: \.description)
    }
  }

  static var UpdateTokenInputType: AppInput<AppSchema.UpdateTokenInput> {
    Input(AppSchema.UpdateTokenInput.self) {
      InputField("id", at: \.id)
      InputField("value", at: \.value)
      InputField("description", at: \.description)
    }
  }

  static var getToken: AppField<Token, IdentifyEntityArgs> {
    Field("getToken", at: Resolver.getToken) {
      Argument("id", at: \.id)
    }
  }

  static var getTokens: AppField<[Token], NoArgs> {
    Field("getTokens", at: Resolver.getTokens)
  }

  static var createToken: AppField<Token, AppSchema.CreateTokenArgs> {
    Field("createToken", at: Resolver.createToken) {
      Argument("input", at: \.input)
    }
  }

  static var createTokens: AppField<[Token], AppSchema.CreateTokensArgs> {
    Field("createTokens", at: Resolver.createTokens) {
      Argument("input", at: \.input)
    }
  }

  static var updateToken: AppField<Token, AppSchema.UpdateTokenArgs> {
    Field("updateToken", at: Resolver.updateToken) {
      Argument("input", at: \.input)
    }
  }

  static var updateTokens: AppField<[Token], AppSchema.UpdateTokensArgs> {
    Field("updateTokens", at: Resolver.updateTokens) {
      Argument("input", at: \.input)
    }
  }

  static var deleteToken: AppField<Token, IdentifyEntityArgs> {
    Field("deleteToken", at: Resolver.deleteToken) {
      Argument("id", at: \.id)
    }
  }
}

extension Token {
  convenience init(_ input: AppSchema.CreateTokenInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      value: .init(rawValue: input.value),
      description: input.description
    )
  }

  convenience init(_ input: AppSchema.UpdateTokenInput) {
    self.init(
      id: .init(rawValue: input.id),
      value: .init(rawValue: input.value),
      description: input.description
    )
  }

  func update(_ input: AppSchema.UpdateTokenInput) {
    value = .init(rawValue: input.value)
    description = input.description
  }
}
