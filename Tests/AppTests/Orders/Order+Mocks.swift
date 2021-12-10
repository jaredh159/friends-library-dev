@testable import App

extension Order {
  static var empty: Order {
    Order(
      lang: .en,
      source: .website,
      paymentId: "",
      printJobStatus: .pending,
      amount: 0,
      taxes: 0,
      ccFeeOffset: 0,
      shipping: 0,
      shippingLevel: .ground,
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
