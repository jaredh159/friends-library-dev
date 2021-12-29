// auto-generated, do not edit
import Foundation
import Tagged

extension OrderItem: AppModel {
  typealias Id = Tagged<OrderItem, UUID>
}

extension OrderItem: DuetModel {
  static let tableName = "order_items"
}

extension OrderItem {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.orderId]: .uuid(orderId),
      Self[.documentId]: .uuid(documentId),
      Self[.editionType]: .enum(editionType),
      Self[.title]: .string(title),
      Self[.quantity]: .int(quantity),
      Self[.unitPrice]: .int(unitPrice.rawValue),
      Self[.createdAt]: .currentTimestamp,
    ]
  }
}

extension OrderItem {
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

extension OrderItem: Auditable {}
