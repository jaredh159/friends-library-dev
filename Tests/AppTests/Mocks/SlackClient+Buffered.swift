import Foundation

@testable import App

extension Slack.Client {
  class MessageBuffer {
    var messages: [Slack.Message]
    init() {
      messages = []
    }
  }

  static func mockAndBuffer() -> Slack.Client.MessageBuffer {
    let buffer = MessageBuffer()
    Current.slackClient = .init(
      send: { buffer.messages.append($0) },
      sendSync: { buffer.messages.append($0) }
    )
    return buffer
  }
}
