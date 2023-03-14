import Tagged

enum Lang: String, Codable, CaseIterable {
  case en
  case es
}

enum EditionType: String, Codable, CaseIterable {
  case updated
  case original
  case modernized
}

enum PrintSizeVariant: String, Codable, CaseIterable {
  case s
  case m
  case xl
  case xlCondensed

  var printSize: PrintSize {
    switch self {
    case .s:
      return .s
    case .m:
      return .m
    case .xl, .xlCondensed:
      return .xl
    }
  }
}

enum PrintSize: String, Codable, CaseIterable {
  case s
  case m
  case xl
}

typealias GitCommitSha = Tagged<(tagged: (), sha: ()), String>
typealias ISBN = Tagged<(tagged: (), isbn: ()), String>
typealias Bytes = Tagged<(tagged: (), bytes: ()), Int>
typealias EmailAddress = Tagged<(tagged: (), emailAddress: ()), String>
