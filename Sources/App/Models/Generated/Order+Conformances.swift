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
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.lang]: .enum(lang),
      Self[.source]: .enum(source),
      Self[.paymentId]: .string(paymentId.rawValue),
      Self[.printJobId]: .int(printJobId?.rawValue),
      Self[.printJobStatus]: .enum(printJobStatus),
      Self[.amount]: .int(amount.rawValue),
      Self[.taxes]: .int(taxes.rawValue),
      Self[.ccFeeOffset]: .int(ccFeeOffset.rawValue),
      Self[.shipping]: .int(shipping.rawValue),
      Self[.shippingLevel]: .enum(shippingLevel),
      Self[.email]: .string(email.rawValue),
      Self[.addressName]: .string(addressName),
      Self[.addressStreet]: .string(addressStreet),
      Self[.addressStreet2]: .string(addressStreet2),
      Self[.addressCity]: .string(addressCity),
      Self[.addressState]: .string(addressState),
      Self[.addressZip]: .string(addressZip),
      Self[.addressCountry]: .string(addressCountry),
      Self[.freeOrderRequestId]: .uuid(freeOrderRequestId),
      Self[.createdAt]: .currentTimestamp,
      Self[.updatedAt]: .currentTimestamp,
    ]
  }
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

extension Order: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "lang":
        return .enum(lang) == constraint.value
      case "source":
        return .enum(source) == constraint.value
      case "paymentId":
        return .string(paymentId.rawValue) == constraint.value
      case "printJobId":
        return .int(printJobId?.rawValue) == constraint.value
      case "printJobStatus":
        return .enum(printJobStatus) == constraint.value
      case "amount":
        return .int(amount.rawValue) == constraint.value
      case "taxes":
        return .int(taxes.rawValue) == constraint.value
      case "ccFeeOffset":
        return .int(ccFeeOffset.rawValue) == constraint.value
      case "shipping":
        return .int(shipping.rawValue) == constraint.value
      case "shippingLevel":
        return .enum(shippingLevel) == constraint.value
      case "email":
        return .string(email.rawValue) == constraint.value
      case "addressName":
        return .string(addressName) == constraint.value
      case "addressStreet":
        return .string(addressStreet) == constraint.value
      case "addressStreet2":
        return .string(addressStreet2) == constraint.value
      case "addressCity":
        return .string(addressCity) == constraint.value
      case "addressState":
        return .string(addressState) == constraint.value
      case "addressZip":
        return .string(addressZip) == constraint.value
      case "addressCountry":
        return .string(addressCountry) == constraint.value
      case "freeOrderRequestId":
        return .uuid(freeOrderRequestId) == constraint.value
      case "createdAt":
        return .date(createdAt) == constraint.value
      case "updatedAt":
        return .date(updatedAt) == constraint.value
      default:
        return false
    }
  }
}

extension Order: Auditable {}
extension Order: Touchable {}
