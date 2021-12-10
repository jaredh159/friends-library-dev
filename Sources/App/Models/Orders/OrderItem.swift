import Fluent
import Tagged
import Vapor

final class OrderItem {
  var id: Id
  var orderId: Order.Id
  var documentId: UUID  // @TODO, should become Document.Id, then be deleted when switching to Edition.Id
  var editionType: EditionType  // @TODO remove
  var title: String
  var quantity: Int
  var unitPrice: Int
  var createdAt = Current.date()
  var order = Parent<Order>.notLoaded

  // var document = Parent<Document>.notLoaded // @TODO, then switch
  // var edition = Parent<Edition>.notLoaded // @TODO, longer-term correct

  init(
    id: Id = .init(),
    orderId: Order.Id,
    documentId: UUID,
    editionType: EditionType,
    title: String,
    quantity: Int,
    unitPrice: Int
  ) {
    self.id = id
    self.orderId = orderId
    self.documentId = documentId
    self.editionType = editionType
    self.title = title
    self.quantity = quantity
    self.unitPrice = unitPrice
  }
}

/// extensions

extension OrderItem: AppModel {
  typealias Id = Tagged<OrderItem, UUID>
}

extension OrderItem: DuetModel {
  static let tableName = "order_items"
}

extension OrderItem: Codable {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case orderId
    case documentId
    case editionType
    case title
    case quantity
    case unitPrice
    case createdAt
  }
}
