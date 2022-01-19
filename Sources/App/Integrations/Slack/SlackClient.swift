import Foundation

extension Slack {
  struct Client {
    var send = send(_:)
    var sendSync = sendSync(_:)
  }

  enum ClientError: Error {
    case failedToSend(String?)
  }
}

private struct SendResponse: Decodable {
  let ok: Bool
  let error: String?
}

private func send(_ slack: Slack.Message) async throws {
  let response = try await HTTP.postJson(
    [
      "channel": slack.channel,
      "text": slack.text,
      "icon_emoji": slack.emoji.description,
      "username": slack.username,
      "unfurl_links": "false",
      "unfurl_media": "false",
    ],
    to: "https://slack.com/api/chat.postMessage",
    decoding: SendResponse.self,
    auth: .bearer(Env.SLACK_API_TOKEN)
  )

  if !response.ok {
    throw Slack.ClientError.failedToSend(response.error)
  }
}

private func sendSync(_ slack: Slack.Message) throws {
  let semaphore = DispatchSemaphore(value: 0)
  Task {
    try await send(slack)
    semaphore.signal()
  }
  _ = semaphore.wait(timeout: .distantFuture)
}

// extensions

extension Slack.Emoji: CustomStringConvertible {
  var description: String {
    switch self {
      case .fireEngine:
        return "fire_engine"
      case .robotFace:
        return "robot_face"
      case .custom(let custom):
        return custom
    }
  }
}

extension Slack.Client {
  static let mock = Slack.Client(send: { _ in }, sendSync: { _ in })
}
