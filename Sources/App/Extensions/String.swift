import Foundation

public extension String {
  func match(_ pattern: String) -> Bool {
    range(of: pattern, options: .regularExpression) != nil
  }

  func replace(_ pattern: String, _ replacement: String) -> String {
    replacingOccurrences(of: pattern, with: replacement, options: .regularExpression)
  }

  var snakeCased: String {
    let acronymPattern = "([A-Z]+)([A-Z][a-z]|[0-9])"
    let normalPattern = "([a-z0-9])([A-Z])"
    return processCamelCaseRegex(pattern: acronymPattern)?
      .processCamelCaseRegex(pattern: normalPattern)?.lowercased() ?? lowercased()
  }

  var shoutyCased: String {
    snakeCased.uppercased()
  }

  func padLeft(toLength: Int, withPad: String) -> String {
    String(
      String(reversed())
        .padding(toLength: toLength, withPad: withPad, startingAt: 0)
        .reversed()
    )
  }

  private func processCamelCaseRegex(pattern: String) -> String? {
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(location: 0, length: count)
    return regex?.stringByReplacingMatches(
      in: self, options: [], range: range, withTemplate: "$1_$2"
    )
  }
}
