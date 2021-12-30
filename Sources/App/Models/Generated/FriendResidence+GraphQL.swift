// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension FriendResidence {
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

extension FriendResidence.GraphQL.Schema {
  static var type: AppType<FriendResidence> {
    Type(FriendResidence.self) {
      Field("id", at: \.id.rawValue)
      Field("friendId", at: \.friendId.rawValue)
      Field("city", at: \.city)
      Field("region", at: \.region)
      Field("duration", at: \.duration)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
    }
  }
}

extension FriendResidence.GraphQL.Request.Inputs {
  struct Create: Codable {
    let id: UUID?
    let friendId: UUID
    let city: String
    let region: String
    let duration: FriendResidence.Duration?
  }

  struct Update: Codable {
    let id: UUID
    let friendId: UUID
    let city: String
    let region: String
    let duration: FriendResidence.Duration?
  }
}

extension FriendResidence.GraphQL.Request.Args {
  struct Create: Codable {
    let input: FriendResidence.GraphQL.Request.Inputs.Create
  }

  struct Update: Codable {
    let input: FriendResidence.GraphQL.Request.Inputs.Update
  }

  struct UpdateMany: Codable {
    let input: [FriendResidence.GraphQL.Request.Inputs.Update]
  }

  struct CreateMany: Codable {
    let input: [FriendResidence.GraphQL.Request.Inputs.Create]
  }
}

extension FriendResidence.GraphQL.Schema.Inputs {
  static var create: AppInput<FriendResidence.GraphQL.Request.Inputs.Create> {
    Input(FriendResidence.GraphQL.Request.Inputs.Create.self) {
      InputField("id", at: \.id)
      InputField("friendId", at: \.friendId)
      InputField("city", at: \.city)
      InputField("region", at: \.region)
      InputField("duration", at: \.duration)
    }
  }

  static var update: AppInput<FriendResidence.GraphQL.Request.Inputs.Update> {
    Input(FriendResidence.GraphQL.Request.Inputs.Update.self) {
      InputField("id", at: \.id)
      InputField("friendId", at: \.friendId)
      InputField("city", at: \.city)
      InputField("region", at: \.region)
      InputField("duration", at: \.duration)
    }
  }
}

extension FriendResidence.GraphQL.Schema.Queries {
  static var get: AppField<FriendResidence, IdentifyEntityArgs> {
    Field("getFriendResidence", at: Resolver.getFriendResidence) {
      Argument("id", at: \.id)
    }
  }

  static var list: AppField<[FriendResidence], NoArgs> {
    Field("getFriendResidences", at: Resolver.getFriendResidences)
  }
}

extension FriendResidence.GraphQL.Schema.Mutations {
  static var create: AppField<FriendResidence, FriendResidence.GraphQL.Request.Args.Create> {
    Field("createFriendResidence", at: Resolver.createFriendResidence) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[FriendResidence], FriendResidence.GraphQL.Request.Args.CreateMany> {
    Field("createFriendResidence", at: Resolver.createFriendResidences) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<FriendResidence, FriendResidence.GraphQL.Request.Args.Update> {
    Field("createFriendResidence", at: Resolver.updateFriendResidence) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[FriendResidence], FriendResidence.GraphQL.Request.Args.UpdateMany> {
    Field("createFriendResidence", at: Resolver.updateFriendResidences) {
      Argument("input", at: \.input)
    }
  }

  static var delete: AppField<FriendResidence, IdentifyEntityArgs> {
    Field("deleteFriendResidence", at: Resolver.deleteFriendResidence) {
      Argument("id", at: \.id)
    }
  }
}

extension FriendResidence {
  convenience init(_ input: FriendResidence.GraphQL.Request.Inputs.Create) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      friendId: .init(rawValue: input.friendId),
      city: input.city,
      region: input.region,
      duration: input.duration
    )
  }

  func update(_ input: FriendResidence.GraphQL.Request.Inputs.Update) throws {
    self.friendId = .init(rawValue: input.friendId)
    self.city = input.city
    self.region = input.region
    self.duration = input.duration
    self.updatedAt = Current.date()
  }
}
