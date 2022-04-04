// auto-generated, do not edit
import DuetSQL
import Tagged

extension Order: ApiModel {
  typealias Id = Tagged<Order, UUID>
}

extension Order: Model {
  static let tableName = M2.tableName
  static var isSoftDeletable: Bool { false }
}

extension Order {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case lang
    case source
    case paymentId
    case printJobId
    case printJobStatus
    case amount
    case taxes
    case fees
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
      .fees: .int(fees.rawValue),
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
  func satisfies(constraint: SQL.WhereConstraint<Order>) -> Bool {
    switch constraint.column {
      case .id:
        return constraint.isSatisfiedBy(.id(self))
      case .lang:
        return constraint.isSatisfiedBy(.enum(lang))
      case .source:
        return constraint.isSatisfiedBy(.enum(source))
      case .paymentId:
        return constraint.isSatisfiedBy(.string(paymentId.rawValue))
      case .printJobId:
        return constraint.isSatisfiedBy(.int(printJobId?.rawValue))
      case .printJobStatus:
        return constraint.isSatisfiedBy(.enum(printJobStatus))
      case .amount:
        return constraint.isSatisfiedBy(.int(amount.rawValue))
      case .taxes:
        return constraint.isSatisfiedBy(.int(taxes.rawValue))
      case .fees:
        return constraint.isSatisfiedBy(.int(fees.rawValue))
      case .ccFeeOffset:
        return constraint.isSatisfiedBy(.int(ccFeeOffset.rawValue))
      case .shipping:
        return constraint.isSatisfiedBy(.int(shipping.rawValue))
      case .shippingLevel:
        return constraint.isSatisfiedBy(.enum(shippingLevel))
      case .email:
        return constraint.isSatisfiedBy(.string(email.rawValue))
      case .addressName:
        return constraint.isSatisfiedBy(.string(addressName))
      case .addressStreet:
        return constraint.isSatisfiedBy(.string(addressStreet))
      case .addressStreet2:
        return constraint.isSatisfiedBy(.string(addressStreet2))
      case .addressCity:
        return constraint.isSatisfiedBy(.string(addressCity))
      case .addressState:
        return constraint.isSatisfiedBy(.string(addressState))
      case .addressZip:
        return constraint.isSatisfiedBy(.string(addressZip))
      case .addressCountry:
        return constraint.isSatisfiedBy(.string(addressCountry))
      case .freeOrderRequestId:
        return constraint.isSatisfiedBy(.uuid(freeOrderRequestId))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
      case .updatedAt:
        return constraint.isSatisfiedBy(.date(updatedAt))
    }
  }
}

extension Order: Auditable {}
extension Order: Touchable {}
