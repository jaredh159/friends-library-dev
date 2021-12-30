// auto-generated, do not edit
import Graphiti
import Vapor

extension Friend {
  enum GraphQL {
    enum Schema {
      enum Queries {}
      enum Mutations {}
    }
    enum Request {}
  }
}

extension Friend.GraphQL.Schema {
  static var type: AppType<Friend> {
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
}

extension Friend.GraphQL.Request {
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
}

extension Friend.GraphQL.Request {
  struct CreateFriendArgs: Codable {
    let input: Friend.GraphQL.Request.CreateFriendInput
  }

  struct UpdateFriendArgs: Codable {
    let input: Friend.GraphQL.Request.UpdateFriendInput
  }

  struct CreateFriendsArgs: Codable {
    let input: [Friend.GraphQL.Request.CreateFriendInput]
  }

  struct UpdateFriendsArgs: Codable {
    let input: [Friend.GraphQL.Request.UpdateFriendInput]
  }
}

extension Friend.GraphQL.Schema {
  static var create: AppInput<Friend.GraphQL.Request.CreateFriendInput> {
    Input(Friend.GraphQL.Request.CreateFriendInput.self) {
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

  static var update: AppInput<Friend.GraphQL.Request.UpdateFriendInput> {
    Input(Friend.GraphQL.Request.UpdateFriendInput.self) {
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
}

extension Friend.GraphQL.Schema.Queries {
  static var get: AppField<Friend, IdentifyEntityArgs> {
    Field("getFriend", at: Resolver.getFriend) {
      Argument("id", at: \.id)
    }
  }

  static var list: AppField<[Friend], NoArgs> {
    Field("getFriends", at: Resolver.getFriends)
  }
}

extension Friend.GraphQL.Schema.Mutations {
  static var create: AppField<Friend, Friend.GraphQL.Request.CreateFriendArgs> {
    Field("createFriend", at: Resolver.createFriend) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[Friend], Friend.GraphQL.Request.CreateFriendsArgs> {
    Field("createFriend", at: Resolver.createFriends) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<Friend, Friend.GraphQL.Request.UpdateFriendArgs> {
    Field("createFriend", at: Resolver.updateFriend) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[Friend], Friend.GraphQL.Request.UpdateFriendsArgs> {
    Field("createFriend", at: Resolver.updateFriends) {
      Argument("input", at: \.input)
    }
  }

  static var delete: AppField<Friend, IdentifyEntityArgs> {
    Field("deleteFriend", at: Resolver.deleteFriend) {
      Argument("id", at: \.id)
    }
  }
}

extension Friend {
  convenience init(_ input: Friend.GraphQL.Request.CreateFriendInput) {
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

  func update(_ input: Friend.GraphQL.Request.UpdateFriendInput) {
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
