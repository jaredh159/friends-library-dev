import Fluent
import Vapor

final class Friend: Model, Content {
  static let schema = M10.tableName

  enum Gender: String, Codable, CaseIterable {
    case male
    case female
    case mixed
  }

  @ID(key: .id)
  var id: UUID?

  @Enum(key: M10.lang)
  var lang: Lang

  @Field(key: M10.name)
  var name: String

  @Field(key: M10.slug)
  var slug: String

  @Enum(key: M10.gender)
  var gender: Gender

  @Field(key: M10.description)
  var description: String

  @OptionalField(key: M10.born)
  var born: Int?

  @Field(key: M10.died)
  var died: Int

  @Field(key: M10.published)
  var published: Date?

  @Timestamp(key: .createdAt, on: .create)
  var createdAt: Date?

  @Timestamp(key: .updatedAt, on: .update)
  var updatedAt: Date?

  @Children(for: \FriendResidence.$friend)
  var residences: [FriendResidence]

  @Children(for: \FriendQuote.$friend)
  var quotes: [FriendQuote]

  @Children(for: \Document.$friend)
  var documents: [Document]

  var isCompilations: Bool {
    slug.starts(with: "compila")
  }

  init() {}
}

extension Friend {
  enum M10 {
    static let tableName = "friends"
    static let lang = FieldKey("lang")
    static let name = FieldKey("name")
    static let slug = FieldKey("slug")
    static let gender = FieldKey("gender")
    static let description = FieldKey("description")
    static let born = FieldKey("born")
    static let died = FieldKey("died")
    static let published = FieldKey("published")
    enum GenderEnum {
      static let name = "gender"
      static let caseMale = "male"
      static let caseFemale = "female"
      static let caseMixed = "mixed"
    }
  }
}
