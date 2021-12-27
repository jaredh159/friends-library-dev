import TaggedMoney

final class OrderItem: Codable {
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
