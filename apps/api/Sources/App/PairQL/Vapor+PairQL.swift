import PairQL
import Vapor

extension RouteResponder where Response == Vapor.Response {
  static func respond<T: PairOutput>(with output: T) throws -> Response {
    try output.response()
  }
}

extension PairOutput {
  func response() throws -> Response {
    Response(
      status: .ok,
      headers: ["Content-Type": "application/json"],
      body: .init(data: try jsonData())
    )
  }
}
