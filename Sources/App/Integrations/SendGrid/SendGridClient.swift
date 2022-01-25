import Foundation

extension SendGrid {
  struct Client {
    var send = send(email:)
  }
}

private func send(email: SendGrid.Email) async throws -> Data? {
  let (data, response) = try await HTTP.postJson(
    email,
    to: "https://api.sendgrid.com/v3/mail/send",
    auth: .bearer(Env.SENDGRID_API_KEY)
  )
  return response.statusCode == 202 ? nil : data
}

// estensions

extension SendGrid.Client {
  static let live: Self = .init(send: send(email:))
  static let mock: Self = .init(send: { _ in nil })
}

// error logging

extension SendGrid.Client {
  struct SlackErrorLogging {
    var send: (SendGrid.Email) async throws -> Void
  }
}

extension SendGrid.Client.SlackErrorLogging {
  static let live: Self = .init(send: { email in
    if let errorData = try await SendGrid.Client().send(email) {
      let msg = """
      **Failed to send SendGrid email**
      Response: `\(String(data: errorData, encoding: .utf8) ?? "<no data>")`
      To: \(email.firstRecipient.email)
      Subject: \(email.subject)
      Body: \(email.html)
      """
      await Current.slackClient.send(.error(msg))
    }
  })
  static let mock: Self = .init(send: { _ in })
}
