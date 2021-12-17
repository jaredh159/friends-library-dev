import Fluent
import Foundation
import Tagged

final class Friend {
  var id: Id
  var lang: Lang
  var name: String
  var slug: String
  var gender: Gender
  var description: String
  var born: Int?
  var died: Int?
  var published: Date?
  var createdAt = Current.date()
  var updatedAt = Current.date()

  var documents = Children<Document>.notLoaded
  var residences = Children<FriendResidence>.notLoaded
  var quotes = Children<FriendQuote>.notLoaded

  var isCompilations: Bool {
    slug.starts(with: "compila")
  }

  init(
    id: Id = .init(),
    lang: Lang,
    name: String,
    slug: String,
    gender: Gender,
    description: String,
    born: Int?,
    died: Int?,
    published: Date?
  ) {
    self.id = id
    self.lang = lang
    self.name = name
    self.slug = slug
    self.gender = gender
    self.description = description
    self.born = born
    self.died = died
    self.published = published
  }
}

// extensions

extension Friend {
  enum Gender: String, Codable, CaseIterable {
    case male
    case female
    case mixed
  }
}

extension Friend: AppModel {
  typealias Id = Tagged<Friend, UUID>
}

extension Friend: DuetModel {
  static let tableName = M10.tableName
}

extension Friend: Codable {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case lang
    case name
    case slug
    case gender
    case description
    case born
    case died
    case published
  }
}

extension Friend.Gender: PostgresEnum {
  var dataType: String { Friend.M10.GenderEnum.name }
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
