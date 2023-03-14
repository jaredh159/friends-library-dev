import Foundation
import XHttp

public extension SendGrid {
  struct Client {
    public init(send: @escaping (SendGrid.Email, String) async throws -> Data?) {
      self.send = send
    }

    public var send = send(email:apiKey:)
  }
}

private func send(email: SendGrid.Email, apiKey: String) async throws -> Data? {
  let (data, response) = try await HTTP.postJson(
    email,
    to: "https://api.sendgrid.com/v3/mail/send",
    auth: .bearer(apiKey),
    keyEncodingStrategy: .convertToSnakeCase
  )
  return response.statusCode == 202 ? nil : data
}

// extensions

public extension SendGrid.Client {
  static var live: Self = .init(send: send(email:apiKey:))
  static var mock: Self = .init(send: { _, _ in nil })
}
