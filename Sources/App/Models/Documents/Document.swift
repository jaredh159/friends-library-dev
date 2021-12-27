import Fluent
import Tagged
import Vapor

final class Document: Codable {
  var id: Id
  var friendId: Friend.Id
  var altLanguageId: Id?
  var title: String
  var slug: String
  var filename: String
  var published: Int?
  var originalTitle: String?
  var incomplete: Bool
  var description: String
  var partialDescription: String
  var featuredDescription: String?
  var createdAt = Current.date()
  var updatedAt = Current.date()
  var deletedAt: Date? = nil

  var friend = Parent<Friend>.notLoaded
  var altLanguageDocument = OptionalParent<Document>.notLoaded
  var relatedDocuments = Children<Document>.notLoaded

  init(
    id: Id = .init(),
    friendId: Friend.Id,
    altLanguageId: Id?,
    title: String,
    slug: String,
    filename: String,
    published: Int?,
    originalTitle: String?,
    incomplete: Bool,
    description: String,
    partialDescription: String,
    featuredDescription: String?
  ) {
    self.id = id
    self.friendId = friendId
    self.slug = slug
    self.altLanguageId = altLanguageId
    self.title = title
    self.filename = filename
    self.published = published
    self.originalTitle = originalTitle
    self.incomplete = incomplete
    self.description = description
    self.partialDescription = partialDescription
    self.featuredDescription = featuredDescription
  }
}

// extensions

extension Document {
  enum M13 {
    static let tableName = "documents"
    static let friendId = FieldKey("friend_id")
    static let altLanguageId = FieldKey("alt_language_id")
    static let title = FieldKey("title")
    static let slug = FieldKey("slug")
    static let filename = FieldKey("filename")
    static let published = FieldKey("published")
    static let description = FieldKey("description")
    static let partialDescription = FieldKey("partial_description")
    static let featuredDescription = FieldKey("featured_description")
    static let originalTitle = FieldKey("original_title")
    static let incomplete = FieldKey("incomplete")
  }
}
