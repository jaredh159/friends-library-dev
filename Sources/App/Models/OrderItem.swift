import Fluent
import Vapor

final class OrderItem: Model, Content {
  static let schema = "order_items"

  @ID(key: .id)
  var id: UUID?

  @Parent(key: "order_id")
  var order: Order

  @Field(key: "title")
  var title: String

  @Field(key: "document_id")
  var documentId: UUID

  @Enum(key: "edition_type")
  var editionType: EditionType

  @Field(key: "quantity")
  var quantity: Int

  @Field(key: "unit_price")
  var unitPrice: Int

  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?

  init() {}
}
