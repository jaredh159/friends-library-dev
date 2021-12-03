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

enum DocumentTag: String, Codable, CaseIterable {
  case journal
  case letters
  case exhortation
  case doctrinal
  case treatise
  case history
  case allegory
  case spiritualLife
}

enum PrintSizeVariant: String, Codable, CaseIterable {
  case s
  case m
  case xl
  case xlCondensed = "xl--condensed"
}

typealias GitCommitSha = Tagged<(tagged: (), sha: ()), String>
typealias ISBN = Tagged<(tagged: (), isbn: ()), String>
