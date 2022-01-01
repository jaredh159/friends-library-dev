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
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.orderId]: .uuid(orderId),
      Self[.editionId]: .uuid(editionId),
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
    case editionId
    case quantity
    case unitPrice
    case createdAt
  }
}

extension OrderItem: Auditable {}
