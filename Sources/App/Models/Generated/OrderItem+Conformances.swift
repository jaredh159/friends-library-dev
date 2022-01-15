// auto-generated, do not edit
import Foundation
import Tagged

extension OrderItem: AppModel {
  typealias Id = Tagged<OrderItem, UUID>
}

extension OrderItem: DuetModel {
  static let tableName = M3.tableName
}

extension OrderItem {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case orderId
    case editionId
    case quantity
    case unitPrice
    case createdAt
  }
}

extension OrderItem {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .orderId: .uuid(orderId),
      .editionId: .uuid(editionId),
      .quantity: .int(quantity),
      .unitPrice: .int(unitPrice.rawValue),
      .createdAt: .currentTimestamp,
    ]
  }
}

extension OrderItem: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "order_id":
        return .uuid(orderId) == constraint.value
      case "edition_id":
        return .uuid(editionId) == constraint.value
      case "quantity":
        return .int(quantity) == constraint.value
      case "unit_price":
        return .int(unitPrice.rawValue) == constraint.value
      case "created_at":
        return .date(createdAt) == constraint.value
      default:
        return false
    }
  }
}

extension OrderItem: Auditable {}
