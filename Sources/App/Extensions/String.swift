import Foundation

extension String {
  public func match(_ pattern: String) -> Bool {
    return self.range(of: pattern, options: .regularExpression) != nil
  }

  public func replace(_ pattern: String, _ replacement: String) -> String {
    return self.replacingOccurrences(of: pattern, with: replacement, options: .regularExpression)
  }

  var snakeCased: String {
    let acronymPattern = "([A-Z]+)([A-Z][a-z]|[0-9])"
    let normalPattern = "([a-z0-9])([A-Z])"
    return self.processCamelCaseRegex(pattern: acronymPattern)?
      .processCamelCaseRegex(pattern: normalPattern)?.lowercased() ?? self.lowercased()
  }

  fileprivate func processCamelCaseRegex(pattern: String) -> String? {
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(location: 0, length: count)
    return regex?.stringByReplacingMatches(
      in: self, options: [], range: range, withTemplate: "$1_$2")
  }
}
