import DuetSQL
import Foundation
import Vapor
import XSendGrid
import XStripe

struct Environment {
  var uuid: () -> UUID = UUID.init
  var date: () -> Date = Date.init
  var db: EntityClient = ThrowingDatabaseClient()
  var auth: Auth = .live
  var logger = Logger(label: "api.friendslibrary")
  var slackClient: FlpSlack.Client = .init()
  var luluClient: Lulu.Api.Client = .live
  var sendGridClient: SendGrid.Client.SlackErrorLogging = .live
  var stripeClient = Stripe.Client()
  var ipApiClient = IpApi.Client()
}

var Current = Environment()

extension UUID {
  static let mock = UUID("DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFDEAD")!
}

func invariant(_ msg: String) -> Never {
  Current.slackClient.sendSync(.error(msg))
  fatalError(msg)
}
