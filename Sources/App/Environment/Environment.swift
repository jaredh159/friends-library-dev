import Foundation
import Vapor

struct Environment {
  var uuid: () -> UUID = UUID.init
  var date: () -> Date = Date.init
  var db: DatabaseClient = ThrowingDatabaseClient()
  var auth: Auth = .live
  var logger = Logger(label: "api.friendslibrary")
  var slackClient: Slack.Client = .init()
  var luluClient: Lulu.Api.Client = .live
  var sendGridClient: SendGrid.Client.SlackErrorLogging = .live
  var stripeClient = Stripe.Client()
}

var Current = Environment()

extension Environment {
  static let mock = Environment(
    uuid: { .mock },
    date: { Date(timeIntervalSince1970: 0) },
    db: MockDatabase(),
    auth: .mockWithAllScopes,
    logger: .null,
    slackClient: .mock,
    luluClient: .mock,
    sendGridClient: .mock,
    stripeClient: .mock
  )
}

extension UUID {
  static let mock = UUID("DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFDEAD")!
}

func invariant(_ msg: String) -> Never {
  Current.slackClient.sendSync(.error(msg))
  fatalError(msg)
}
