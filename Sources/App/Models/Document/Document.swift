import Fluent
import Vapor

final class Document: Model, Content {
  static let schema = M13.tableName

  @ID(key: .id)
  var id: UUID?

  @Parent(key: M13.friendId)
  var friend: Friend

  @OptionalParent(key: M13.altLanguageId)
  var altLanguageDocument: Document?

  @Field(key: M13.title)
  var title: String

  @Field(key: M13.slug)
  var slug: String

  @Field(key: M13.filename)
  var filename: String

  @OptionalField(key: M13.published)
  var published: Int?

  @OptionalField(key: M13.originalTitle)
  var originalTitle: String?

  @Field(key: M13.incomplete)
  var incomplete: Bool

  @Field(key: M13.description)
  var description: String

  @Field(key: M13.partialDescription)
  var partialDescription: String

  @OptionalField(key: M13.featuredDescription)
  var featuredDescription: String?

  @Timestamp(key: .createdAt, on: .create)
  var createdAt: Date?

  @Timestamp(key: .updatedAt, on: .update)
  var updatedAt: Date?

  @Timestamp(key: .deletedAt, on: .delete)
  var deletedAt: Date?

  init() {}

  /*
  - tags (pivot)
  - editions (children)
  - related_documents (children? pivot?)
  */
}

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
