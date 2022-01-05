extension Int {
  static var random: Int {
    Int.random(in: 1_000_000_000...9_999_999_999)
  }
}

extension Int64 {
  static var random: Int64 {
    Int64.random(in: 1_000_000_000...9_999_999_999)
  }
}

extension String {
  var random: String {
    "\(self) \(Int.random)"
  }
}
