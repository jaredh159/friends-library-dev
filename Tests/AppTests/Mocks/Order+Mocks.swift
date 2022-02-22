// auto-generated, do not edit
import GraphQL

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
      fees: 42,
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
      fees: 0,
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

  static var random: Order {
    Order(
      lang: Lang.allCases.shuffled().first!,
      source: OrderSource.allCases.shuffled().first!,
      paymentId: .init(rawValue: "@random".random),
      printJobStatus: PrintJobStatus.allCases.shuffled().first!,
      amount: .init(rawValue: Int.random),
      taxes: .init(rawValue: Int.random),
      fees: .init(rawValue: Int.random),
      ccFeeOffset: .init(rawValue: Int.random),
      shipping: .init(rawValue: Int.random),
      shippingLevel: ShippingLevel.allCases.shuffled().first!,
      email: .init(rawValue: "@random".random),
      addressName: "@random".random,
      addressStreet: "@random".random,
      addressStreet2: Bool.random() ? "@random".random : nil,
      addressCity: "@random".random,
      addressState: "@random".random,
      addressZip: "@random".random,
      addressCountry: "@random".random
    )
  }

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "id": .string(id.lowercased),
      "lang": .string(lang.rawValue),
      "source": .string(source.rawValue),
      "paymentId": .string(paymentId.rawValue),
      "printJobId": printJobId != nil ? .number(Number(printJobId!.rawValue)) : .null,
      "printJobStatus": .string(printJobStatus.rawValue),
      "amount": .number(Number(amount.rawValue)),
      "taxes": .number(Number(taxes.rawValue)),
      "fees": .number(Number(fees.rawValue)),
      "ccFeeOffset": .number(Number(ccFeeOffset.rawValue)),
      "shipping": .number(Number(shipping.rawValue)),
      "shippingLevel": .string(shippingLevel.rawValue),
      "email": .string(email.rawValue),
      "addressName": .string(addressName),
      "addressStreet": .string(addressStreet),
      "addressStreet2": addressStreet2 != nil ? .string(addressStreet2!) : .null,
      "addressCity": .string(addressCity),
      "addressState": .string(addressState),
      "addressZip": .string(addressZip),
      "addressCountry": .string(addressCountry),
      "freeOrderRequestId": freeOrderRequestId != nil ? .string(freeOrderRequestId!.lowercased) : .null,
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
