// auto-generated, do not edit
import DuetSQL
import Tagged

extension Order: ApiModel {
  typealias Id = Tagged<Order, UUID>
}

extension Order: Model {
  static let tableName = M2.tableName

  func postgresData(for column: ColumnName) -> Postgres.Data {
    switch column {
    case .id:
      return .id(self)
    case .lang:
      return .enum(lang)
    case .source:
      return .enum(source)
    case .paymentId:
      return .string(paymentId.rawValue)
    case .printJobId:
      return .int(printJobId?.rawValue)
    case .printJobStatus:
      return .enum(printJobStatus)
    case .amount:
      return .int(amount.rawValue)
    case .taxes:
      return .int(taxes.rawValue)
    case .fees:
      return .int(fees.rawValue)
    case .ccFeeOffset:
      return .int(ccFeeOffset.rawValue)
    case .shipping:
      return .int(shipping.rawValue)
    case .shippingLevel:
      return .enum(shippingLevel)
    case .email:
      return .string(email.rawValue)
    case .addressName:
      return .string(addressName)
    case .addressStreet:
      return .string(addressStreet)
    case .addressStreet2:
      return .string(addressStreet2)
    case .addressCity:
      return .string(addressCity)
    case .addressState:
      return .string(addressState)
    case .addressZip:
      return .string(addressZip)
    case .addressCountry:
      return .string(addressCountry)
    case .freeOrderRequestId:
      return .uuid(freeOrderRequestId)
    case .createdAt:
      return .date(createdAt)
    case .updatedAt:
      return .date(updatedAt)
    }
  }
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
