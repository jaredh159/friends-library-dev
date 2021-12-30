// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var FriendType: AppType<Friend> {
    Type(Friend.self) {
      Field("id", at: \.id.rawValue)
      Field("lang", at: \.lang)
      Field("name", at: \.name)
      Field("slug", at: \.slug)
      Field("gender", at: \.gender)
      Field("description", at: \.description)
      Field("born", at: \.born)
      Field("died", at: \.died)
      Field("published", at: \.published)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
    }
  }

  struct CreateFriendInput: Codable {
    let id: UUID?
    let lang: Lang
    let name: String
    let slug: String
    let gender: Friend.Gender
    let description: String
    let born: Int?
    let died: Int?
    let published: Date?
  }

  struct UpdateFriendInput: Codable {
    let id: UUID
    let lang: Lang
    let name: String
    let slug: String
    let gender: Friend.Gender
    let description: String
    let born: Int?
    let died: Int?
    let published: Date?
  }

  struct CreateFriendArgs: Codable {
    let input: AppSchema.CreateFriendInput
  }

  struct UpdateFriendArgs: Codable {
    let input: AppSchema.UpdateFriendInput
  }

  struct CreateFriendsArgs: Codable {
    let input: [AppSchema.CreateFriendInput]
  }

  struct UpdateFriendsArgs: Codable {
    let input: [AppSchema.UpdateFriendInput]
  }

  static var CreateFriendInputType: AppInput<AppSchema.CreateFriendInput> {
    Input(AppSchema.CreateFriendInput.self) {
      InputField("id", at: \.id)
      InputField("lang", at: \.lang)
      InputField("name", at: \.name)
      InputField("slug", at: \.slug)
      InputField("gender", at: \.gender)
      InputField("description", at: \.description)
      InputField("born", at: \.born)
      InputField("died", at: \.died)
      InputField("published", at: \.published)
    }
  }

  static var UpdateFriendInputType: AppInput<AppSchema.UpdateFriendInput> {
    Input(AppSchema.UpdateFriendInput.self) {
      InputField("id", at: \.id)
      InputField("lang", at: \.lang)
      InputField("name", at: \.name)
      InputField("slug", at: \.slug)
      InputField("gender", at: \.gender)
      InputField("description", at: \.description)
      InputField("born", at: \.born)
      InputField("died", at: \.died)
      InputField("published", at: \.published)
    }
  }

  static var getFriend: AppField<Friend, IdentifyEntityArgs> {
    Field("getFriend", at: Resolver.getFriend) {
      Argument("id", at: \.id)
    }
  }

  static var getFriends: AppField<[Friend], NoArgs> {
    Field("getFriends", at: Resolver.getFriends)
  }

  static var createFriend: AppField<Friend, AppSchema.CreateFriendArgs> {
    Field("createFriend", at: Resolver.createFriend) {
      Argument("input", at: \.input)
    }
  }

  static var createFriends: AppField<[Friend], AppSchema.CreateFriendsArgs> {
    Field("createFriends", at: Resolver.createFriends) {
      Argument("input", at: \.input)
    }
  }

  static var updateFriend: AppField<Friend, AppSchema.UpdateFriendArgs> {
    Field("updateFriend", at: Resolver.updateFriend) {
      Argument("input", at: \.input)
    }
  }

  static var updateFriends: AppField<[Friend], AppSchema.UpdateFriendsArgs> {
    Field("updateFriends", at: Resolver.updateFriends) {
      Argument("input", at: \.input)
    }
  }

  static var deleteFriend: AppField<Friend, IdentifyEntityArgs> {
    Field("deleteFriend", at: Resolver.deleteFriend) {
      Argument("id", at: \.id)
    }
  }
}

extension Friend {
  convenience init(_ input: AppSchema.CreateFriendInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      lang: input.lang,
      name: input.name,
      slug: input.slug,
      gender: input.gender,
      description: input.description,
      born: input.born,
      died: input.died,
      published: input.published
    )
  }

  func update(_ input: AppSchema.UpdateFriendInput) {
    self.lang = input.lang
    self.name = input.name
    self.slug = input.slug
    self.gender = input.gender
    self.description = input.description
    self.born = input.born
    self.died = input.died
    self.published = input.published
    self.updatedAt = Current.date()
  }
}
