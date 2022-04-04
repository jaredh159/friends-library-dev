import Foundation

@testable import App

extension Environment {
  static let mock = Environment(
    uuid: { .mock },
    date: { Date(timeIntervalSince1970: 0) },
    db: MockClient(),
    auth: .mockWithAllScopes,
    logger: .null,
    slackClient: .mock,
    luluClient: .mock,
    sendGridClient: .mock,
    stripeClient: .mock,
    ipApiClient: .mock
  )
}
