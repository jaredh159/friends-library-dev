// auto-generated, do not edit
@testable import App

extension Order {
  static var mock: Order {
    Order(
      lang: .en,
      source: .website,
      paymentId: .init(rawValue: "@mock paymentId"),
      printJobStatus: .presubmit,
      amount: 42,
      taxes: 42,
      ccFeeOffset: 42,
      shipping: 42,
      shippingLevel: .mail,
      email: "mock@mock.com",
      addressName: "@mock addressName",
      addressStreet: "@mock addressStreet",
      addressStreet2: nil,
      addressCity: "@mock addressCity",
      addressState: "@mock addressState",
      addressZip: "@mock addressZip",
      addressCountry: "@mock addressCountry"
    )
  }

  static var empty: Order {
    Order(
      lang: .en,
      source: .website,
      paymentId: .init(rawValue: ""),
      printJobStatus: .presubmit,
      amount: 0,
      taxes: 0,
      ccFeeOffset: 0,
      shipping: 0,
      shippingLevel: .mail,
      email: "",
      addressName: "",
      addressStreet: "",
      addressStreet2: nil,
      addressCity: "",
      addressState: "",
      addressZip: "",
      addressCountry: ""
    )
  }
}
