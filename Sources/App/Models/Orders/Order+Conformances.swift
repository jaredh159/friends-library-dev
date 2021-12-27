// auto-generated, do not edit
import Foundation
import Tagged

extension Order: AppModel {
  typealias Id = Tagged<Order, UUID>
}

extension Order: DuetModel {
  static let tableName = M2.tableName
}

extension Order: DuetInsertable {
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

extension Order: Auditable {}
extension Order: Touchable {}
