// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension Isbn {
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

extension Isbn.GraphQL.Request.Inputs {
  struct Create: Codable {
    let id: UUID?
    let code: String
    let editionId: UUID?
  }

  struct Update: Codable {
    let id: UUID
    let code: String
    let editionId: UUID?
  }
}

extension Isbn.GraphQL.Request.Args {
  struct Create: Codable {
    let input: Isbn.GraphQL.Request.Inputs.Create
  }

  struct Update: Codable {
    let input: Isbn.GraphQL.Request.Inputs.Update
  }

  struct UpdateMany: Codable {
    let input: [Isbn.GraphQL.Request.Inputs.Update]
  }

  struct CreateMany: Codable {
    let input: [Isbn.GraphQL.Request.Inputs.Create]
  }
}

extension Isbn.GraphQL.Schema.Inputs {
  static var create: AppInput<Isbn.GraphQL.Request.Inputs.Create> {
    Input(Isbn.GraphQL.Request.Inputs.Create.self) {
      InputField("id", at: \.id)
      InputField("code", at: \.code)
      InputField("editionId", at: \.editionId)
    }
  }

  static var update: AppInput<Isbn.GraphQL.Request.Inputs.Update> {
    Input(Isbn.GraphQL.Request.Inputs.Update.self) {
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
  static var create: AppField<Isbn, Isbn.GraphQL.Request.Args.Create> {
    Field("createIsbn", at: Resolver.createIsbn) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[Isbn], Isbn.GraphQL.Request.Args.CreateMany> {
    Field("createIsbn", at: Resolver.createIsbns) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<Isbn, Isbn.GraphQL.Request.Args.Update> {
    Field("createIsbn", at: Resolver.updateIsbn) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[Isbn], Isbn.GraphQL.Request.Args.UpdateMany> {
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
  convenience init(_ input: Isbn.GraphQL.Request.Inputs.Create) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      code: .init(rawValue: input.code),
      editionId: input.editionId != nil ? .init(rawValue: input.editionId!) : nil
    )
  }

  func update(_ input: Isbn.GraphQL.Request.Inputs.Update) throws {
    self.code = .init(rawValue: input.code)
    self.editionId = input.editionId != nil ? .init(rawValue: input.editionId!) : nil
    self.updatedAt = Current.date()
  }
}
