import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

struct SlackClient {
  var send = send(_:)
  var sendSync = sendSync(_:)
}

private func send(_ slack: Slack) async throws {
  _ = try await URLSession.shared.data(for: slack.urlRequest())
}

private func sendSync(_ slack: Slack) throws {
  let request = try slack.urlRequest()
  let semaphore = DispatchSemaphore(value: 0)
  URLSession.shared.dataTask(with: request) { _, _, _ in
    semaphore.signal()
  }.resume()
  _ = semaphore.wait(timeout: .distantFuture)
}

// extensions

extension Slack {
  func urlRequest() throws -> URLRequest {
    let url = URL(string: "https://slack.com/api/chat.postMessage")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(Env.SLACK_API_TOKEN)", forHTTPHeaderField: "Authorization")

    request.httpBody = try JSONEncoder().encode([
      "channel": channel,
      "text": text,
      "icon_emoji": emoji.description,
      "username": username,
      "unfurl_links": "false",
      "unfurl_media": "false",
    ])
    return request
  }
}

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

extension SlackClient {
  static let mock = SlackClient(send: { _ in }, sendSync: { _ in })
}
