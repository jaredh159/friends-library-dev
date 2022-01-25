import Foundation

struct UserAgentDeviceData: Decodable {
  let isBot: Bool
  let os: String
  let browser: String
  let platform: String
}

extension UserAgentDeviceData {
  init?(userAgent: String) {
    let parse = Process()
    parse.executableURL = URL(fileURLWithPath: Env.PARSE_USERAGENT_BIN)
    parse.arguments = [userAgent]
    let outPipe = Pipe()
    parse.standardOutput = outPipe
    try? parse.run()
    let data = outPipe.fileHandleForReading.readDataToEndOfFile()
    guard let decoded = try? JSONDecoder().decode(Self.self, from: data) else {
      return nil
    }
    self = decoded
  }
}
