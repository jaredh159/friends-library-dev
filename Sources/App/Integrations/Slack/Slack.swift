enum Slack {}

extension Slack {
  enum Emoji {
    case fireEngine
    case robotFace
    case books
    case orangeBook
    case custom(String)
  }

  enum Channel {
    case errors
    case info
    case orders
    case downloads
    case audioDownloads
    case debug
    case other(String)
  }

  struct Message {
    let text: String
    let channel: Channel
    let emoji: Emoji
    let username: String

    init(
      text: String,
      channel: Channel,
      emoji: Emoji = .robotFace,
      username: String = "FLP Bot"
    ) {
      self.text = text
      self.channel = channel
      self.emoji = emoji
      self.username = username
    }
  }
}

extension Slack.Message {
  static func error(_ text: String, emoji: Slack.Emoji = .fireEngine) -> Slack.Message {
    .init(text: text, channel: .errors, emoji: emoji)
  }

  static func info(_ text: String, emoji: Slack.Emoji = .robotFace) -> Slack.Message {
    .init(text: text, channel: .info, emoji: emoji)
  }

  static func order(_ text: String, emoji: Slack.Emoji = .books) -> Slack.Message {
    .init(text: text, channel: .orders, emoji: emoji)
  }

  static func download(_ text: String, emoji: Slack.Emoji = .robotFace) -> Slack.Message {
    .init(text: text, channel: .downloads, emoji: emoji)
  }

  static func audio(_ text: String, emoji: Slack.Emoji = .robotFace) -> Slack.Message {
    .init(text: text, channel: .audioDownloads, emoji: emoji)
  }

  static func debug(_ text: String, emoji: Slack.Emoji = .robotFace) -> Slack.Message {
    .init(text: text, channel: .debug, emoji: emoji)
  }
}

func slackError(_ msg: String) async {
  await Current.slackClient.send(.error(msg))
}

func slackDebug(_ msg: String) async {
  await Current.slackClient.send(.debug(msg))
}

func slackAudio(_ msg: String) async {
  await Current.slackClient.send(.audio(msg))
}

func slackDownload(_ msg: String) async {
  await Current.slackClient.send(.download(msg))
}

func slackInfo(_ msg: String) async {
  await Current.slackClient.send(.info(msg))
}

func slackOrder(_ msg: String) async {
  await Current.slackClient.send(.order(msg))
}

extension Slack.Emoji: Equatable {}
extension Slack.Channel: Equatable {}
extension Slack.Message: Equatable {}
