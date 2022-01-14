import Foundation
import Vapor

struct Environment {
  var uuid: () -> UUID = UUID.init
  var date: () -> Date = Date.init
  var db: DbClient = ThrowingDbClient()
  var auth: Auth = .live
  var logger = Logger(label: "api.friendslibrary")
  var slackClient: SlackClient = .init()
}

var Current = Environment()

extension UUID {
  static let mock = UUID("3EFC3511-999E-4385-A071-E5B0965C4AFD")!
}

func invariant(_ msg: String) -> Never {
  let slack = Slack(text: msg, channel: "errors", emoji: .fireEngine)
  try! Current.slackClient.sendSync(slack)
  fatalError(msg)
}
