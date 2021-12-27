// auto-generated, do not edit
import Foundation
import Tagged

extension Order: AppModel {
  typealias Id = Tagged<Order, UUID>
}

extension Order: DuetModel {
  static let tableName = M2.tableName
}

extension Order {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case lang
    case source
    case paymentId
    case printJobId
    case printJobStatus
    case amount
    case taxes
    case ccFeeOffset
    case shipping
    case shippingLevel
    case email
    case addressName
    case addressStreet
    case addressStreet2
    case addressCity
    case addressState
    case addressZip
    case addressCountry
    case freeOrderRequestId
    case createdAt
    case updatedAt
  }
}
