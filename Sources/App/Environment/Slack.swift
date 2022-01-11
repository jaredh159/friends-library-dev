struct Slack {
  let text: String
  let channel: String
  let username: String
  let emoji: Emoji

  enum Emoji {
    case fireEngine
    case robotFace
    case custom(String)
  }

  init(
    text: String,
    channel: String,
    emoji: Emoji = .robotFace,
    username: String = "FLP Bot"
  ) {
    self.text = text
    self.channel = channel
    self.emoji = emoji
    self.username = username
  }
}
