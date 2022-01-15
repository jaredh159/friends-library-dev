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

extension Order {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .lang: .enum(lang),
      .source: .enum(source),
      .paymentId: .string(paymentId.rawValue),
      .printJobId: .int(printJobId?.rawValue),
      .printJobStatus: .enum(printJobStatus),
      .amount: .int(amount.rawValue),
      .taxes: .int(taxes.rawValue),
      .ccFeeOffset: .int(ccFeeOffset.rawValue),
      .shipping: .int(shipping.rawValue),
      .shippingLevel: .enum(shippingLevel),
      .email: .string(email.rawValue),
      .addressName: .string(addressName),
      .addressStreet: .string(addressStreet),
      .addressStreet2: .string(addressStreet2),
      .addressCity: .string(addressCity),
      .addressState: .string(addressState),
      .addressZip: .string(addressZip),
      .addressCountry: .string(addressCountry),
      .freeOrderRequestId: .uuid(freeOrderRequestId),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }
}

extension Order: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "lang":
        return .enum(lang) == constraint.value
      case "source":
        return .enum(source) == constraint.value
      case "payment_id":
        return .string(paymentId.rawValue) == constraint.value
      case "print_job_id":
        return .int(printJobId?.rawValue) == constraint.value
      case "print_job_status":
        return .enum(printJobStatus) == constraint.value
      case "amount":
        return .int(amount.rawValue) == constraint.value
      case "taxes":
        return .int(taxes.rawValue) == constraint.value
      case "cc_fee_offset":
        return .int(ccFeeOffset.rawValue) == constraint.value
      case "shipping":
        return .int(shipping.rawValue) == constraint.value
      case "shipping_level":
        return .enum(shippingLevel) == constraint.value
      case "email":
        return .string(email.rawValue) == constraint.value
      case "address_name":
        return .string(addressName) == constraint.value
      case "address_street":
        return .string(addressStreet) == constraint.value
      case "address_street2":
        return .string(addressStreet2) == constraint.value
      case "address_city":
        return .string(addressCity) == constraint.value
      case "address_state":
        return .string(addressState) == constraint.value
      case "address_zip":
        return .string(addressZip) == constraint.value
      case "address_country":
        return .string(addressCountry) == constraint.value
      case "free_order_request_id":
        return .uuid(freeOrderRequestId) == constraint.value
      case "created_at":
        return .date(createdAt) == constraint.value
      case "updated_at":
        return .date(updatedAt) == constraint.value
      default:
        return false
    }
  }
}

extension Order: Auditable {}
extension Order: Touchable {}
