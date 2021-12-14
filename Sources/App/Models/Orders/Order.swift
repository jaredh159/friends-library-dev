import Fluent
import Tagged
import TaggedMoney
import Vapor

final class Order {
  var id: Id
  var lang: Lang
  var source: OrderSource
  var paymentId: PaymentId
  var printJobId: PrintJobId?
  var printJobStatus: PrintJobStatus
  var amount: Cents<Int>
  var taxes: Cents<Int>
  var ccFeeOffset: Cents<Int>
  var shipping: Cents<Int>
  var shippingLevel: ShippingLevel
  var email: EmailAddress
  var addressName: String
  var addressStreet: String
  var addressStreet2: String?
  var addressCity: String
  var addressState: String
  var addressZip: String
  var addressCountry: String
  var createdAt = Current.date()
  var updatedAt = Current.date()

  var items = Children<OrderItem>.notLoaded

  init(
    id: Id = .init(),
    printJobId: PrintJobId? = nil,
    lang: Lang,
    source: OrderSource,
    paymentId: PaymentId,
    printJobStatus: PrintJobStatus,
    amount: Cents<Int>,
    taxes: Cents<Int>,
    ccFeeOffset: Cents<Int>,
    shipping: Cents<Int>,
    shippingLevel: ShippingLevel,
    email: EmailAddress,
    addressName: String,
    addressStreet: String,
    addressStreet2: String?,
    addressCity: String,
    addressState: String,
    addressZip: String,
    addressCountry: String
  ) {
    self.id = id
    self.printJobId = printJobId
    self.lang = lang
    self.source = source
    self.paymentId = paymentId
    self.printJobStatus = printJobStatus
    self.amount = amount
    self.taxes = taxes
    self.ccFeeOffset = ccFeeOffset
    self.shipping = shipping
    self.shippingLevel = shippingLevel
    self.email = email
    self.addressName = addressName
    self.addressStreet = addressStreet
    self.addressStreet2 = addressStreet2
    self.addressCity = addressCity
    self.addressState = addressState
    self.addressZip = addressZip
    self.addressCountry = addressCountry
  }

  // @TODO
  // @OptionalParent(key: M7.freeOrderRequestId)
  // var freeOrderRequest: FreeOrderRequest?
}

/// extensions

extension Order {
  enum PrintJobStatus: String, Codable, CaseIterable {
    case presubmit
    case pending
    case accepted
    case rejected
    case shipped
    case canceled
    case bricked
  }

  enum ShippingLevel: String, Codable, CaseIterable {
    case mail
    case priorityMail
    case groundHd
    case ground
    case expedited
    case express
  }

  enum OrderSource: String, Codable, CaseIterable {
    case website
    case `internal`
  }
}

extension Lang: PostgresEnum {
  var dataType: String { Order.M2.LangEnum.name }
}

extension Order.OrderSource: PostgresEnum {
  var dataType: String { Order.M2.SourceEnum.name }
}

extension Order.ShippingLevel: PostgresEnum {
  var dataType: String { Order.M2.ShippingLevelEnum.name }
}

extension Order.PrintJobStatus: PostgresEnum {
  var dataType: String { Order.M2.PrintJobStatusEnum.name }
}

extension Order: AppModel {
  typealias Id = Tagged<Order, UUID>
  typealias PaymentId = Tagged<(order: Order, paymentId: ()), String>
  typealias PrintJobId = Tagged<(order: Order, printJobId: ()), Int>
}

extension Order: DuetModel {
  static let tableName = M2.tableName
}

extension Order: Codable {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case lang
    case amount
    case taxes
    case ccFeeOffset
    case shipping
    case shippingLevel
    case paymentId
    case printJobId
    case printJobStatus
    case email
    case source
    case addressName
    case addressStreet
    case addressStreet2
    case addressCity
    case addressState
    case addressZip
    case addressCountry
    case createdAt
    case updatedAt
  }
}

extension Order {
  enum M2 {
    static let tableName = "orders"
    static let id = FieldKey("id")
    static let paymentId = FieldKey("payment_id")
    static let printJobStatus = FieldKey("print_job_status")
    static let printJobId = FieldKey("print_job_id")
    static let amount = FieldKey("amount")
    static let shipping = FieldKey("shipping")
    static let taxes = FieldKey("taxes")
    static let ccFeeOffset = FieldKey("cc_fee_offset")
    static let shippingLevel = FieldKey("shipping_level")
    static let email = FieldKey("email")
    static let addressName = FieldKey("address_name")
    static let addressStreet = FieldKey("address_street")
    static let addressStreet2 = FieldKey("address_street2")
    static let addressCity = FieldKey("address_city")
    static let addressState = FieldKey("address_state")
    static let addressZip = FieldKey("address_zip")
    static let addressCountry = FieldKey("address_country")
    static let lang = FieldKey("lang")
    static let source = FieldKey("source")

    enum PrintJobStatusEnum {
      static let name = "order_print_job_status"
      static let casePresubmit = "presubmit"
      static let casePending = "pending"
      static let caseAccepted = "accepted"
      static let caseRejected = "rejected"
      static let caseShipped = "shipped"
      static let caseCanceled = "canceled"
      static let caseBricked = "bricked"
    }

    enum ShippingLevelEnum {
      static let name = "order_shipping_level"
      static let caseMail = "mail"
      static let casePriorityMail = "priorityMail"
      static let caseGroundHd = "groundHd"
      static let caseGround = "ground"
      static let caseExpedited = "expedited"
      static let caseExpress = "express"
    }

    enum LangEnum {
      static let name = "lang"
      static let caseEn = "en"
      static let caseEs = "es"
    }

    enum SourceEnum {
      static let name = "order_source"
      static let caseWebsite = "website"
      static let caseInternal = "internal"
    }
  }

  enum M7 {
    static let freeOrderRequestId = FieldKey("free_order_request_id")
  }
}
