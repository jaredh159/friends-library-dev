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
    struct ShippingCost: Decodable {
      var totalCostExclTax: String
    }

    struct Fee: Decodable {
      var totalCostExclTax: String
    }

    var totalCostInclTax: String
    var totalTax: String
    var shippingCost: ShippingCost
    var fees: [Fee]
  }
}

extension ShippingAddress {
  var lulu: Lulu.Api.ShippingAddress {
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

extension Order.ShippingLevel {
  var lulu: Lulu.Api.ShippingOptionLevel {
    switch self {
      case .mail:
        return .mail
      case .priorityMail:
        return .priorityMail
      case .groundHd:
        return .groundHd
      case .groundBus:
        return .groundBus
      case .ground:
        return .ground
      case .expedited:
        return .expedited
      case .express:
        return .express
    }
  }
}
