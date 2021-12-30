// auto-generated, do not edit
import Graphiti
import Vapor

extension Isbn {
  enum GraphQL {
    enum Schema {
      enum Queries {}
      enum Mutations {}
    }
    enum Request {}
  }
}

extension Isbn.GraphQL.Schema {
  static var type: AppType<Isbn> {
    Type(Isbn.self) {
      Field("id", at: \.id.rawValue)
      Field("code", at: \.code.rawValue)
      Field("editionId", at: \.editionId?.rawValue)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
    }
  }
}

extension Isbn.GraphQL.Request {
  struct CreateIsbnInput: Codable {
    let id: UUID?
    let code: String
    let editionId: UUID?
  }

  struct UpdateIsbnInput: Codable {
    let id: UUID
    let code: String
    let editionId: UUID?
  }
}

extension Isbn.GraphQL.Request {
  struct CreateIsbnArgs: Codable {
    let input: Isbn.GraphQL.Request.CreateIsbnInput
  }

  struct UpdateIsbnArgs: Codable {
    let input: Isbn.GraphQL.Request.UpdateIsbnInput
  }

  struct CreateIsbnsArgs: Codable {
    let input: [Isbn.GraphQL.Request.CreateIsbnInput]
  }

  struct UpdateIsbnsArgs: Codable {
    let input: [Isbn.GraphQL.Request.UpdateIsbnInput]
  }
}

extension Isbn.GraphQL.Schema {
  static var create: AppInput<Isbn.GraphQL.Request.CreateIsbnInput> {
    Input(Isbn.GraphQL.Request.CreateIsbnInput.self) {
      InputField("id", at: \.id)
      InputField("code", at: \.code)
      InputField("editionId", at: \.editionId)
    }
  }

  static var update: AppInput<Isbn.GraphQL.Request.UpdateIsbnInput> {
    Input(Isbn.GraphQL.Request.UpdateIsbnInput.self) {
      InputField("id", at: \.id)
      InputField("code", at: \.code)
      InputField("editionId", at: \.editionId)
    }
  }
}

extension Isbn.GraphQL.Schema.Queries {
  static var get: AppField<Isbn, IdentifyEntityArgs> {
    Field("getIsbn", at: Resolver.getIsbn) {
      Argument("id", at: \.id)
    }
  }

  static var list: AppField<[Isbn], NoArgs> {
    Field("getIsbns", at: Resolver.getIsbns)
  }
}

extension Isbn.GraphQL.Schema.Mutations {
  static var create: AppField<Isbn, Isbn.GraphQL.Request.CreateIsbnArgs> {
    Field("createIsbn", at: Resolver.createIsbn) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[Isbn], Isbn.GraphQL.Request.CreateIsbnsArgs> {
    Field("createIsbn", at: Resolver.createIsbns) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<Isbn, Isbn.GraphQL.Request.UpdateIsbnArgs> {
    Field("createIsbn", at: Resolver.updateIsbn) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[Isbn], Isbn.GraphQL.Request.UpdateIsbnsArgs> {
    Field("createIsbn", at: Resolver.updateIsbns) {
      Argument("input", at: \.input)
    }
  }

  static var delete: AppField<Isbn, IdentifyEntityArgs> {
    Field("deleteIsbn", at: Resolver.deleteIsbn) {
      Argument("id", at: \.id)
    }
  }
}

extension Isbn {
  convenience init(_ input: Isbn.GraphQL.Request.CreateIsbnInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      code: .init(rawValue: input.code),
      editionId: input.editionId != nil ? .init(rawValue: input.editionId!) : nil
    )
  }

  func update(_ input: Isbn.GraphQL.Request.UpdateIsbnInput) {
    self.code = .init(rawValue: input.code)
    self.editionId = input.editionId != nil ? .init(rawValue: input.editionId!) : nil
    self.updatedAt = Current.date()
  }
}
