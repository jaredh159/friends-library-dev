import Foundation

extension Lulu.Api {
  enum ShippingOptionLevel: String, CaseIterable, Codable {
    case mail = "MAIL"
    case priorityMail = "PRIORITY_MAIL"
    case groundHd = "GROUND_HD"
    case groundBus = "GROUND_BUS"
    case ground = "GROUND"
    case expedited = "EXPEDITED"
    case express = "EXPRESS"
  }

  struct CredentialsResponse: Decodable {
    let accessToken: String
    let expiresIn: Double
  }

  struct ShippingAddress: Codable {
    let name: String
    let street1: String
    let street2: String?
    let countryCode: String
    let city: String
    let stateCode: String
    let postcode: String
  }

  struct PrintJobCostCalculationsBody: Encodable {
    struct LineItem: Encodable {
      let pageCount: Int
      let podPackageId: String
      let quantity: Int
    }

    let lineItems: [LineItem]
    let shippingAddress: ShippingAddress
    let shippingOption: ShippingOptionLevel
  }

  struct PrintJobCostCalculationResponse: Decodable {
    struct LineItemCost: Decodable {
      let costExclDiscounts: String
      let totalTax: String
      let taxRate: String
      let quantity: Int
      let totalCostExclDiscounts: String
      let totalCostExclTax: String
      let totalCostInclTax: String
    }

    struct ShippingCost: Decodable {
      let totalCostExclTax: String
      let totalCostInclTax: String
      let taxRate: String
      let totalTax: String
    }

    let currency: String
    let totalCostExclTax: String
    let totalCostInclTax: String
    let totalDiscountAmount: String
    let totalTax: String
    let shippingCost: ShippingCost
    let lineItemCosts: [LineItemCost]
  }
}

extension ShippingAddress {
  var luluAddress: Lulu.Api.ShippingAddress {
    .init(
      name: name,
      street1: street,
      street2: street2,
      countryCode: country,
      city: city,
      stateCode: state,
      postcode: zip
    )
  }
}
