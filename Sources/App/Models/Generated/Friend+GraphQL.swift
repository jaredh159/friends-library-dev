// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension Friend {
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

extension Friend.GraphQL.Request.Inputs {
  struct Create: Codable {
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

  struct Update: Codable {
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

extension Friend.GraphQL.Request.Args {
  struct Create: Codable {
    let input: Friend.GraphQL.Request.Inputs.Create
  }

  struct Update: Codable {
    let input: Friend.GraphQL.Request.Inputs.Update
  }

  struct UpdateMany: Codable {
    let input: [Friend.GraphQL.Request.Inputs.Update]
  }

  struct CreateMany: Codable {
    let input: [Friend.GraphQL.Request.Inputs.Create]
  }
}

extension Friend.GraphQL.Schema.Inputs {
  static var create: AppInput<Friend.GraphQL.Request.Inputs.Create> {
    Input(Friend.GraphQL.Request.Inputs.Create.self) {
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

  static var update: AppInput<Friend.GraphQL.Request.Inputs.Update> {
    Input(Friend.GraphQL.Request.Inputs.Update.self) {
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
  static var create: AppField<Friend, Friend.GraphQL.Request.Args.Create> {
    Field("createFriend", at: Resolver.createFriend) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[Friend], Friend.GraphQL.Request.Args.CreateMany> {
    Field("createFriend", at: Resolver.createFriends) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<Friend, Friend.GraphQL.Request.Args.Update> {
    Field("createFriend", at: Resolver.updateFriend) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[Friend], Friend.GraphQL.Request.Args.UpdateMany> {
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
  convenience init(_ input: Friend.GraphQL.Request.Inputs.Create) throws {
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

  func update(_ input: Friend.GraphQL.Request.Inputs.Update) throws {
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
