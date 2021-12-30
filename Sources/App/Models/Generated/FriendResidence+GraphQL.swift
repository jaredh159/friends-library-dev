// auto-generated, do not edit
import Graphiti
import Vapor

extension FriendResidence {
  enum GraphQL {
    enum Schema {
      enum Queries {}
      enum Mutations {}
    }
    enum Request {}
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

extension FriendResidence.GraphQL.Request {
  struct CreateFriendResidenceInput: Codable {
    let id: UUID?
    let friendId: UUID
    let city: String
    let region: String
    let duration: FriendResidence.Duration?
  }

  struct UpdateFriendResidenceInput: Codable {
    let id: UUID
    let friendId: UUID
    let city: String
    let region: String
    let duration: FriendResidence.Duration?
  }
}

extension FriendResidence.GraphQL.Request {
  struct CreateFriendResidenceArgs: Codable {
    let input: FriendResidence.GraphQL.Request.CreateFriendResidenceInput
  }

  struct UpdateFriendResidenceArgs: Codable {
    let input: FriendResidence.GraphQL.Request.UpdateFriendResidenceInput
  }

  struct CreateFriendResidencesArgs: Codable {
    let input: [FriendResidence.GraphQL.Request.CreateFriendResidenceInput]
  }

  struct UpdateFriendResidencesArgs: Codable {
    let input: [FriendResidence.GraphQL.Request.UpdateFriendResidenceInput]
  }
}

extension FriendResidence.GraphQL.Schema {
  static var create: AppInput<FriendResidence.GraphQL.Request.CreateFriendResidenceInput> {
    Input(FriendResidence.GraphQL.Request.CreateFriendResidenceInput.self) {
      InputField("id", at: \.id)
      InputField("friendId", at: \.friendId)
      InputField("city", at: \.city)
      InputField("region", at: \.region)
      InputField("duration", at: \.duration)
    }
  }

  static var update: AppInput<FriendResidence.GraphQL.Request.UpdateFriendResidenceInput> {
    Input(FriendResidence.GraphQL.Request.UpdateFriendResidenceInput.self) {
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
  static var create: AppField<FriendResidence, FriendResidence.GraphQL.Request.CreateFriendResidenceArgs> {
    Field("createFriendResidence", at: Resolver.createFriendResidence) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[FriendResidence], FriendResidence.GraphQL.Request.CreateFriendResidencesArgs> {
    Field("createFriendResidence", at: Resolver.createFriendResidences) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<FriendResidence, FriendResidence.GraphQL.Request.UpdateFriendResidenceArgs> {
    Field("createFriendResidence", at: Resolver.updateFriendResidence) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[FriendResidence], FriendResidence.GraphQL.Request.UpdateFriendResidencesArgs> {
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
  convenience init(_ input: FriendResidence.GraphQL.Request.CreateFriendResidenceInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      friendId: .init(rawValue: input.friendId),
      city: input.city,
      region: input.region,
      duration: input.duration
    )
  }

  func update(_ input: FriendResidence.GraphQL.Request.UpdateFriendResidenceInput) {
    self.friendId = .init(rawValue: input.friendId)
    self.city = input.city
    self.region = input.region
    self.duration = input.duration
    self.updatedAt = Current.date()
  }
}
