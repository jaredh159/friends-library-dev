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

// maybe this should be moved inside of `DownloadableFile`, and
// renamed `Identifier`?
enum DownloadFormat: Equatable, Encodable {
  enum Ebook: String, Codable, CaseIterable, Equatable {
    case epub
    case mobi
    case pdf
    case speech
    case app
  }

  enum Audio: Equatable, Encodable {
    enum Quality: Equatable, Encodable {
      case high
      case low
    }

    case podcast(Quality)
    case mp3Zip(Quality)
    case m4b(Quality)
    case mp3(quality: Quality, multipartIndex: Int?)
  }

  enum Paperback: String, Codable, CaseIterable, Equatable {
    case cover
    case interior
  }

  case ebook(Ebook)
  case audio(Audio)
  case paperback(type: Paperback, volumeIndex: Int?)
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
