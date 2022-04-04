// auto-generated, do not edit
import DuetSQL
import Tagged

extension OrderItem: ApiModel {
  typealias Id = Tagged<OrderItem, UUID>
}

extension OrderItem: Model {
  static let tableName = M3.tableName
  static var isSoftDeletable: Bool { false }
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
        return constraint.isSatisfiedBy(.id(self))
      case .orderId:
        return constraint.isSatisfiedBy(.uuid(orderId))
      case .editionId:
        return constraint.isSatisfiedBy(.uuid(editionId))
      case .quantity:
        return constraint.isSatisfiedBy(.int(quantity))
      case .unitPrice:
        return constraint.isSatisfiedBy(.int(unitPrice.rawValue))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
    }
  }
}

extension OrderItem: Auditable {}
