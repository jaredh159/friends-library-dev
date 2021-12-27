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
