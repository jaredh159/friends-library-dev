import Foundation

extension Lulu.Api {

  struct Client {
    var createPrintJob: (CreatePrintJobBody) async throws -> PrintJob
    var createPrintJobCostCalculation: (
      ShippingAddress,
      ShippingOptionLevel,
      [PrintJobCostCalculationsBody.LineItem]
    ) async throws -> PrintJobCostCalculationResponse
  }
}

extension Lulu.Api.Client {
  static let live: Self = .init(
    createPrintJob: createPrintJob(_:),
    createPrintJobCostCalculation: printJobCost(address:shippingLevel:items:)
  )
}

private func createPrintJob(
  _ body: Lulu.Api.CreatePrintJobBody
) async throws -> Lulu.Api.PrintJob {
  try await postJson(body, to: "print-jobs/", decoding: Lulu.Api.PrintJob.self)
}

private func printJobCost(
  address: Lulu.Api.ShippingAddress,
  shippingLevel: Lulu.Api.ShippingOptionLevel,
  items: [Lulu.Api.PrintJobCostCalculationsBody.LineItem]
) async throws -> Lulu.Api.PrintJobCostCalculationResponse {
  try await postJson(
    Lulu.Api.PrintJobCostCalculationsBody(
      lineItems: items,
      shippingAddress: address,
      shippingOption: shippingLevel
    ),
    to: "print-job-cost-calculations/",
    decoding: Lulu.Api.PrintJobCostCalculationResponse.self
  )
}

private func postJson<Body: Encodable, Response: Decodable>(
  _ body: Body,
  to path: String,
  decoding: Response.Type
) async throws -> Response {
  try await HTTP.postJson(
    body,
    to: "\(Env.LULU_API_ENDPOINT)\(path)",
    decoding: Response.self,
    auth: .bearer(try await luluToken.get()),
    keyEncodingStrategy: .convertToSnakeCase,
    keyDecodingStrategy: .convertFromSnakeCase
  )
}

extension Lulu.Api.Client {
  static let mock: Self = .init(
    createPrintJob: { _ in .init(id: 1, status: .init(name: .created), lineItems: []) },
    createPrintJobCostCalculation: { _, _, _ in
      .init(
        totalCostInclTax: "0.00",
        totalTax: "0.00",
        shippingCost: .init(totalCostExclTax: "0.00"),
        fees: [.init(totalCostExclTax: "0.00")]
      )
    }
  )
}
