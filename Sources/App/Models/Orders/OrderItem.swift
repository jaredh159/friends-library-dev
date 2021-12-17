import Fluent
import Tagged
import TaggedMoney
import Vapor

final class OrderItem {
  var id: Id
  var orderId: Order.Id
  var documentId: Document.Id
  var editionType: EditionType  // @TODO remove
  var title: String  // @TODO, also redundant, could join on the edition...
  var quantity: Int
  var unitPrice: Cents<Int>
  var createdAt = Current.date()
  var order = Parent<Order>.notLoaded

  var document = Parent<Document>.notLoaded

  // var edition = Parent<Edition>.notLoaded // @TODO, longer-term correct

  init(
    id: Id = .init(),
    orderId: Order.Id,
    documentId: Document.Id,
    editionType: EditionType,
    title: String,
    quantity: Int,
    unitPrice: Cents<Int>
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
