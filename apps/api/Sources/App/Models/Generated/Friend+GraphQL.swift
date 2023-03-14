// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var FriendType: ModelType<Friend> {
    Type(Friend.self) {
      Field("id", at: \.id.rawValue.lowercased)
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
      Field("isCompilations", at: \.isCompilations)
      Field("directoryPath", at: \.directoryPath)
      Field("hasNonDraftDocument", at: \.hasNonDraftDocument)
      Field("relatedDocuments", at: \.relatedDocuments)
      Field("alphabeticalName", at: \.alphabeticalName)
      Field("primaryResidence", at: \.primaryResidence)
      Field("isValid", at: \.isValid)
      Field("documents", with: \.documents)
      Field("residences", with: \.residences)
      Field("quotes", with: \.quotes)
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
    let published: String?
    let deletedAt: String?
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
    let published: String?
    let deletedAt: String?
  }

  static var CreateFriendInputType: AppInput<CreateFriendInput> {
    Input(CreateFriendInput.self) {
      InputField("id", at: \.id)
      InputField("lang", at: \.lang)
      InputField("name", at: \.name)
      InputField("slug", at: \.slug)
      InputField("gender", at: \.gender)
      InputField("description", at: \.description)
      InputField("born", at: \.born)
      InputField("died", at: \.died)
      InputField("published", at: \.published)
      InputField("deletedAt", at: \.deletedAt)
    }
  }

  static var UpdateFriendInputType: AppInput<UpdateFriendInput> {
    Input(UpdateFriendInput.self) {
      InputField("id", at: \.id)
      InputField("lang", at: \.lang)
      InputField("name", at: \.name)
      InputField("slug", at: \.slug)
      InputField("gender", at: \.gender)
      InputField("description", at: \.description)
      InputField("born", at: \.born)
      InputField("died", at: \.died)
      InputField("published", at: \.published)
      InputField("deletedAt", at: \.deletedAt)
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

  static var createFriend: AppField<Friend, InputArgs<CreateFriendInput>> {
    Field("createFriend", at: Resolver.createFriend) {
      Argument("input", at: \.input)
    }
  }

  static var createFriends: AppField<[Friend], InputArgs<[CreateFriendInput]>> {
    Field("createFriends", at: Resolver.createFriends) {
      Argument("input", at: \.input)
    }
  }

  static var updateFriend: AppField<Friend, InputArgs<UpdateFriendInput>> {
    Field("updateFriend", at: Resolver.updateFriend) {
      Argument("input", at: \.input)
    }
  }

  static var updateFriends: AppField<[Friend], InputArgs<[UpdateFriendInput]>> {
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
  convenience init(_ input: AppSchema.CreateFriendInput) throws {
    self.init(
      lang: input.lang,
      name: input.name,
      slug: input.slug,
      gender: input.gender,
      description: input.description,
      born: input.born,
      died: input.died,
      published: try input.published.flatMap { try Date(fromIsoString: $0) }
    )
    if let id = input.id {
      self.id = .init(rawValue: id)
    }
  }

  convenience init(_ input: AppSchema.UpdateFriendInput) throws {
    self.init(
      id: .init(rawValue: input.id),
      lang: input.lang,
      name: input.name,
      slug: input.slug,
      gender: input.gender,
      description: input.description,
      born: input.born,
      died: input.died,
      published: try input.published.flatMap { try Date(fromIsoString: $0) }
    )
  }

  func update(_ input: AppSchema.UpdateFriendInput) throws {
    lang = input.lang
    name = input.name
    slug = input.slug
    gender = input.gender
    description = input.description
    born = input.born
    died = input.died
    published = try input.published.flatMap { try Date(fromIsoString: $0) }
    deletedAt = try input.deletedAt.flatMap { try Date(fromIsoString: $0) }
    updatedAt = Current.date()
  }
}
