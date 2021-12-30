// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension FreeOrderRequest {
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

extension FreeOrderRequest.GraphQL.Schema {
  static var type: AppType<FreeOrderRequest> {
    Type(FreeOrderRequest.self) {
      Field("id", at: \.id.rawValue)
      Field("name", at: \.name)
      Field("email", at: \.email.rawValue)
      Field("requestedBooks", at: \.requestedBooks)
      Field("aboutRequester", at: \.aboutRequester)
      Field("addressStreet", at: \.addressStreet)
      Field("addressStreet2", at: \.addressStreet2)
      Field("addressCity", at: \.addressCity)
      Field("addressState", at: \.addressState)
      Field("addressZip", at: \.addressZip)
      Field("addressCountry", at: \.addressCountry)
      Field("source", at: \.source)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
    }
  }
}

extension FreeOrderRequest.GraphQL.Request.Inputs {
  struct Create: Codable {
    let id: UUID?
    let name: String
    let email: String
    let requestedBooks: String
    let aboutRequester: String
    let addressStreet: String
    let addressStreet2: String?
    let addressCity: String
    let addressState: String
    let addressZip: String
    let addressCountry: String
    let source: String
  }

  struct Update: Codable {
    let id: UUID
    let name: String
    let email: String
    let requestedBooks: String
    let aboutRequester: String
    let addressStreet: String
    let addressStreet2: String?
    let addressCity: String
    let addressState: String
    let addressZip: String
    let addressCountry: String
    let source: String
  }
}

extension FreeOrderRequest.GraphQL.Request.Args {
  struct Create: Codable {
    let input: FreeOrderRequest.GraphQL.Request.Inputs.Create
  }

  struct Update: Codable {
    let input: FreeOrderRequest.GraphQL.Request.Inputs.Update
  }

  struct UpdateMany: Codable {
    let input: [FreeOrderRequest.GraphQL.Request.Inputs.Update]
  }

  struct CreateMany: Codable {
    let input: [FreeOrderRequest.GraphQL.Request.Inputs.Create]
  }
}

extension FreeOrderRequest.GraphQL.Schema.Inputs {
  static var create: AppInput<FreeOrderRequest.GraphQL.Request.Inputs.Create> {
    Input(FreeOrderRequest.GraphQL.Request.Inputs.Create.self) {
      InputField("id", at: \.id)
      InputField("name", at: \.name)
      InputField("email", at: \.email)
      InputField("requestedBooks", at: \.requestedBooks)
      InputField("aboutRequester", at: \.aboutRequester)
      InputField("addressStreet", at: \.addressStreet)
      InputField("addressStreet2", at: \.addressStreet2)
      InputField("addressCity", at: \.addressCity)
      InputField("addressState", at: \.addressState)
      InputField("addressZip", at: \.addressZip)
      InputField("addressCountry", at: \.addressCountry)
      InputField("source", at: \.source)
    }
  }

  static var update: AppInput<FreeOrderRequest.GraphQL.Request.Inputs.Update> {
    Input(FreeOrderRequest.GraphQL.Request.Inputs.Update.self) {
      InputField("id", at: \.id)
      InputField("name", at: \.name)
      InputField("email", at: \.email)
      InputField("requestedBooks", at: \.requestedBooks)
      InputField("aboutRequester", at: \.aboutRequester)
      InputField("addressStreet", at: \.addressStreet)
      InputField("addressStreet2", at: \.addressStreet2)
      InputField("addressCity", at: \.addressCity)
      InputField("addressState", at: \.addressState)
      InputField("addressZip", at: \.addressZip)
      InputField("addressCountry", at: \.addressCountry)
      InputField("source", at: \.source)
    }
  }
}

extension FreeOrderRequest.GraphQL.Schema.Queries {
  static var get: AppField<FreeOrderRequest, IdentifyEntityArgs> {
    Field("getFreeOrderRequest", at: Resolver.getFreeOrderRequest) {
      Argument("id", at: \.id)
    }
  }

  static var list: AppField<[FreeOrderRequest], NoArgs> {
    Field("getFreeOrderRequests", at: Resolver.getFreeOrderRequests)
  }
}

extension FreeOrderRequest.GraphQL.Schema.Mutations {
  static var create: AppField<FreeOrderRequest, FreeOrderRequest.GraphQL.Request.Args.Create> {
    Field("createFreeOrderRequest", at: Resolver.createFreeOrderRequest) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[FreeOrderRequest], FreeOrderRequest.GraphQL.Request.Args.CreateMany> {
    Field("createFreeOrderRequest", at: Resolver.createFreeOrderRequests) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<FreeOrderRequest, FreeOrderRequest.GraphQL.Request.Args.Update> {
    Field("createFreeOrderRequest", at: Resolver.updateFreeOrderRequest) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[FreeOrderRequest], FreeOrderRequest.GraphQL.Request.Args.UpdateMany> {
    Field("createFreeOrderRequest", at: Resolver.updateFreeOrderRequests) {
      Argument("input", at: \.input)
    }
  }

  static var delete: AppField<FreeOrderRequest, IdentifyEntityArgs> {
    Field("deleteFreeOrderRequest", at: Resolver.deleteFreeOrderRequest) {
      Argument("id", at: \.id)
    }
  }
}

extension FreeOrderRequest {
  convenience init(_ input: FreeOrderRequest.GraphQL.Request.Inputs.Create) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      name: input.name,
      email: .init(rawValue: input.email),
      requestedBooks: input.requestedBooks,
      aboutRequester: input.aboutRequester,
      addressStreet: input.addressStreet,
      addressStreet2: input.addressStreet2,
      addressCity: input.addressCity,
      addressState: input.addressState,
      addressZip: input.addressZip,
      addressCountry: input.addressCountry,
      source: input.source
    )
  }

  func update(_ input: FreeOrderRequest.GraphQL.Request.Inputs.Update) throws {
    self.name = input.name
    self.email = .init(rawValue: input.email)
    self.requestedBooks = input.requestedBooks
    self.aboutRequester = input.aboutRequester
    self.addressStreet = input.addressStreet
    self.addressStreet2 = input.addressStreet2
    self.addressCity = input.addressCity
    self.addressState = input.addressState
    self.addressZip = input.addressZip
    self.addressCountry = input.addressCountry
    self.source = input.source
    self.updatedAt = Current.date()
  }
}
