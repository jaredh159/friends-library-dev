import Foundation

extension Lulu.Api {

  struct Client {
    var createPrintJobCostCalculation: (
      ShippingAddress,
      ShippingOptionLevel,
      [PrintJobCostCalculationsBody.LineItem]
    ) async throws -> PrintJobCostCalculationResponse
  }
}

extension Lulu.Api.Client {
  static let live: Self = .init(
    createPrintJobCostCalculation: printJobCost(address:shippingLevel:items:)
  )
}

private func printJobCost(
  address: Lulu.Api.ShippingAddress,
  shippingLevel: Lulu.Api.ShippingOptionLevel,
  items: [Lulu.Api.PrintJobCostCalculationsBody.LineItem]
) async throws -> Lulu.Api.PrintJobCostCalculationResponse {
  try await HTTP.postJson(
    Lulu.Api.PrintJobCostCalculationsBody(
      lineItems: items,
      shippingAddress: address,
      shippingOption: shippingLevel
    ),
    to: "\(Env.LULU_API_ENDPOINT)/print-job-cost-calculations/",
    decoding: Lulu.Api.PrintJobCostCalculationResponse.self,
    auth: .bearer(try await luluToken.get()),
    keyEncodingStrategy: .convertToSnakeCase,
    keyDecodingStrategy: .convertFromSnakeCase
  )
}
