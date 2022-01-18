// auto-generated, do not edit
import Foundation
import Tagged

extension OrderItem: ApiModel {
  typealias Id = Tagged<OrderItem, UUID>
}

extension OrderItem: DuetModel {
  static let tableName = M3.tableName
}

extension OrderItem {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
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
  func satisfies(constraint: SQL.WhereConstraint<OrderItem>) -> Bool {
    switch constraint.column {
      case .id:
        return .id(self) == constraint.value
      case .orderId:
        return .uuid(orderId) == constraint.value
      case .editionId:
        return .uuid(editionId) == constraint.value
      case .quantity:
        return .int(quantity) == constraint.value
      case .unitPrice:
        return .int(unitPrice.rawValue) == constraint.value
      case .createdAt:
        return .date(createdAt) == constraint.value
    }
  }
}

extension OrderItem: Auditable {}
