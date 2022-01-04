// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var FriendResidenceType: AppType<FriendResidence> {
    Type(FriendResidence.self) {
      Field("id", at: \.id.rawValue)
      Field("friendId", at: \.friendId.rawValue)
      Field("city", at: \.city)
      Field("region", at: \.region)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
      Field("friend", with: \.friend)
      Field("durations", with: \.durations)
    }
  }

  struct CreateFriendResidenceInput: Codable {
    let id: UUID?
    let friendId: UUID
    let city: String
    let region: String
  }

  struct UpdateFriendResidenceInput: Codable {
    let id: UUID
    let friendId: UUID
    let city: String
    let region: String
  }

  struct CreateFriendResidenceArgs: Codable {
    let input: AppSchema.CreateFriendResidenceInput
  }

  struct UpdateFriendResidenceArgs: Codable {
    let input: AppSchema.UpdateFriendResidenceInput
  }

  struct CreateFriendResidencesArgs: Codable {
    let input: [AppSchema.CreateFriendResidenceInput]
  }

  struct UpdateFriendResidencesArgs: Codable {
    let input: [AppSchema.UpdateFriendResidenceInput]
  }

  static var CreateFriendResidenceInputType: AppInput<AppSchema.CreateFriendResidenceInput> {
    Input(AppSchema.CreateFriendResidenceInput.self) {
      InputField("id", at: \.id)
      InputField("friendId", at: \.friendId)
      InputField("city", at: \.city)
      InputField("region", at: \.region)
    }
  }

  static var UpdateFriendResidenceInputType: AppInput<AppSchema.UpdateFriendResidenceInput> {
    Input(AppSchema.UpdateFriendResidenceInput.self) {
      InputField("id", at: \.id)
      InputField("friendId", at: \.friendId)
      InputField("city", at: \.city)
      InputField("region", at: \.region)
    }
  }

  static var getFriendResidence: AppField<FriendResidence, IdentifyEntityArgs> {
    Field("getFriendResidence", at: Resolver.getFriendResidence) {
      Argument("id", at: \.id)
    }
  }

  static var getFriendResidences: AppField<[FriendResidence], NoArgs> {
    Field("getFriendResidences", at: Resolver.getFriendResidences)
  }

  static var createFriendResidence: AppField<FriendResidence, AppSchema.CreateFriendResidenceArgs> {
    Field("createFriendResidence", at: Resolver.createFriendResidence) {
      Argument("input", at: \.input)
    }
  }

  static var createFriendResidences: AppField<[FriendResidence], AppSchema.CreateFriendResidencesArgs> {
    Field("createFriendResidences", at: Resolver.createFriendResidences) {
      Argument("input", at: \.input)
    }
  }

  static var updateFriendResidence: AppField<FriendResidence, AppSchema.UpdateFriendResidenceArgs> {
    Field("updateFriendResidence", at: Resolver.updateFriendResidence) {
      Argument("input", at: \.input)
    }
  }

  static var updateFriendResidences: AppField<[FriendResidence], AppSchema.UpdateFriendResidencesArgs> {
    Field("updateFriendResidences", at: Resolver.updateFriendResidences) {
      Argument("input", at: \.input)
    }
  }

  static var deleteFriendResidence: AppField<FriendResidence, IdentifyEntityArgs> {
    Field("deleteFriendResidence", at: Resolver.deleteFriendResidence) {
      Argument("id", at: \.id)
    }
  }
}

extension FriendResidence {
  convenience init(_ input: AppSchema.CreateFriendResidenceInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      friendId: .init(rawValue: input.friendId),
      city: input.city,
      region: input.region
    )
  }

  convenience init(_ input: AppSchema.UpdateFriendResidenceInput) {
    self.init(
      id: .init(rawValue: input.id),
      friendId: .init(rawValue: input.friendId),
      city: input.city,
      region: input.region
    )
  }

  func update(_ input: AppSchema.UpdateFriendResidenceInput) {
    self.friendId = .init(rawValue: input.friendId)
    self.city = input.city
    self.region = input.region
    self.updatedAt = Current.date()
  }
}
