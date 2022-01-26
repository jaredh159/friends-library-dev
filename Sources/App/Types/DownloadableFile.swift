import Foundation
import Graphiti

struct DownloadableFile: Encodable {
  let edition: Edition
  let format: DownloadFormat

  var sourcePath: String {
    "\(edition.directoryPath)/\(filename)"
  }

  var sourceUrl: URL {
    URL(string: "\(Env.CLOUD_STORAGE_BUCKET_URL)/\(sourcePath)")!
  }

  var logUrl: URL {
    URL(string: "\(Env.CLOUD_STORAGE_BUCKET_URL)/\(logPath)")!
  }

  var filename: String {
    switch format {
      case .ebook(.epub):
        return "\(edition.filename).epub"
      case .ebook(.mobi):
        return "\(edition.filename).mobi"
      case .ebook(.pdf):
        return "\(edition.filename).pdf"
      case .ebook(.speech):
        return "\(edition.filename).html"
      case .ebook(.app):
        return "\(edition.filename)--(app-ebook).html"
      case .paperback(.interior, let index):
        return "\(edition.filename)--(print)\(index |> volumeFilenameSuffix).pdf"
      case .paperback(.cover, let index):
        return "\(edition.filename)--cover\(index |> volumeFilenameSuffix).pdf"
      case .audio(.m4b(let quality)):
        return "\(edition.filename)\(quality |> qualityFilenameSuffix).m4b"
      case .audio(.mp3Zip(let quality)):
        return "\(edition.filename)--mp3s\(quality |> qualityFilenameSuffix).zip"
      case .audio(.mp3(let quality, let index)):
        return "\(edition.filename)\(index |> partFilenameSuffix)\(quality |> qualityFilenameSuffix).mp3"
      case .audio(.podcast):
        return "podcast.rss"
    }
  }

  var logPath: String {
    let id = edition.id.lowercased
    switch format {
      case .ebook(.epub):
        return "download/\(id)/ebook/epub"
      case .ebook(.mobi):
        return "download/\(id)/ebook/mobi"
      case .ebook(.pdf):
        return "download/\(id)/ebook/pdf"
      case .ebook(.speech):
        return "download/\(id)/ebook/speech"
      case .ebook(.app):
        return "download/\(id)/ebook/app"
      case .paperback(.interior, let index):
        return "download/\(id)/paperback/interior\(index |> volumeLogPathSuffix)"
      case .paperback(.cover, let index):
        return "download/\(id)/paperback/cover\(index |> volumeLogPathSuffix)"
      case .audio(.m4b(let quality)):
        return "download/\(id)/audio/m4b\(quality |> qualityLogPathSuffix)"
      case .audio(.mp3Zip(let quality)):
        return "download/\(id)/audio/mp3s\(quality |> qualityLogPathSuffix)"
      case .audio(.mp3(let quality, let index)):
        return "download/\(id)/audio/mp3\(index |> partLogPathSuffix)\(quality |> qualityLogPathSuffix)"
      case .audio(.podcast(let quality)):
        return "download/\(id)/audio/podcast\(quality |> qualityLogPathSuffix)/podcast.rss"
    }
  }
}

// parsing init

extension DownloadableFile {
  init?(logPath: String) async throws {
    var segments = logPath.split(separator: "/")

    guard !segments.isEmpty, segments.removeFirst() == "download" else {
      throw ParseLogPathError.missingLeadingDownload(logPath)
    }

    guard !segments.isEmpty else {
      throw ParseLogPathError.missingEditionId(logPath)
    }

    guard let editionUuid = UUID(uuidString: segments.removeFirst() |> String.init) else {
      throw ParseLogPathError.invalidEditionId(logPath)
    }

    guard let edition = try? await Current.db.find(Edition.Id(rawValue: editionUuid)) else {
      throw ParseLogPathError.editionNotFound(logPath)
    }

    switch segments.joined(separator: "/") {
      case "ebook/epub":
        self = .init(edition: edition, format: .ebook(.epub))
      case "ebook/mobi":
        self = .init(edition: edition, format: .ebook(.mobi))
      case "ebook/pdf":
        self = .init(edition: edition, format: .ebook(.pdf))
      case "ebook/speech":
        self = .init(edition: edition, format: .ebook(.speech))
      case "ebook/app":
        self = .init(edition: edition, format: .ebook(.app))
      case "paperback/interior":
        self = .init(edition: edition, format: .paperback(type: .interior, volumeIndex: nil))
      case "paperback/cover":
        self = .init(edition: edition, format: .paperback(type: .cover, volumeIndex: nil))
      case "audio/podcast/hq/podcast.rss":
        self = .init(edition: edition, format: .audio(.podcast(.high)))
      case "audio/podcast/lq/podcast.rss":
        self = .init(edition: edition, format: .audio(.podcast(.low)))
      case "audio/m4b/hq":
        self = .init(edition: edition, format: .audio(.m4b(.high)))
      case "audio/m4b/lq":
        self = .init(edition: edition, format: .audio(.m4b(.low)))
      case "audio/mp3s/hq":
        self = .init(edition: edition, format: .audio(.mp3Zip(.high)))
      case "audio/mp3s/lq":
        self = .init(edition: edition, format: .audio(.mp3Zip(.low)))
      case "audio/mp3/hq":
        self = .init(edition: edition, format: .audio(.mp3(quality: .high, multipartIndex: nil)))
      case "audio/mp3/lq":
        self = .init(edition: edition, format: .audio(.mp3(quality: .low, multipartIndex: nil)))
      default:
        guard segments.count >= 3 else {
          throw ParseLogPathError.invalid(logPath)
        }

        let first = segments.removeFirst()
        let second = segments.removeFirst()
        let third = segments.removeFirst()

        switch (first, second) {
          case ("paperback", "interior"):
            guard let index = third |> toIndex, validatePaperbackVolume(edition, index) else {
              throw ParseLogPathError.invalidPaperbackVolume(logPath)
            }
            self = .init(edition: edition, format: .paperback(type: .interior, volumeIndex: index))
          case ("paperback", "cover"):
            guard let index = third |> toIndex else {
              throw ParseLogPathError.invalidPaperbackVolume(logPath)
            }
            self = .init(edition: edition, format: .paperback(type: .cover, volumeIndex: index))
          case ("audio", "mp3"):
            guard let index = third |> toIndex, validateMp3Part(edition, index) else {
              throw ParseLogPathError.invalidMp3Part(logPath)
            }
            switch segments.first {
              case "hq":
                self = .init(
                  edition: edition,
                  format: .audio(.mp3(quality: .high, multipartIndex: index))
                )
              case "lq":
                self = .init(
                  edition: edition,
                  format: .audio(.mp3(quality: .low, multipartIndex: index))
                )
              default:
                throw ParseLogPathError.invalidMp3Part(logPath)
            }
          default:
            throw ParseLogPathError.invalid(logPath)
        }
    }
  }

  enum ParseLogPathError: Error {
    case missingLeadingDownload(String)
    case missingEditionId(String)
    case invalidEditionId(String)
    case editionNotFound(String)
    case invalid(String)
    case invalidPaperbackVolume(String)
    case invalidMp3Part(String)
  }
}

// graphql extensions

extension AppSchema {
  static var DownloadableFileType: AppType<DownloadableFile> {
    Type(DownloadableFile.self) {
      Field("logPath", at: \.logPath)
      Field("sourcePath", at: \.sourcePath)
      Field("logUrl", at: \.logUrl.absoluteString)
      Field("sourceUrl", at: \.sourceUrl.absoluteString)
    }
  }
}

// helpers

private func validatePaperbackVolume(_ edition: Edition, _ index: Int) -> Bool {
  guard let impression = edition.impression.require() else {
    return false
  }
  return index >= 0 && index < impression.paperbackVolumes.count
}

private func validateMp3Part(_ edition: Edition, _ index: Int) -> Bool {
  guard let audio = edition.audio.require() else {
    return false
  }
  return index >= 0 && index < audio.parts.require().count
}

private func toIndex(_ segment: String.SubSequence) -> Int? {
  guard segment.allSatisfy(\.isWholeNumber),
        let index = Int(String(segment)),
        index > 0 else { return nil }
  return index - 1
}

private func volumeFilenameSuffix(_ index: Int?) -> String {
  guard let index = index else { return "" }
  return "--v\(index + 1)"
}

private func volumeLogPathSuffix(_ index: Int?) -> String {
  guard let index = index else { return "" }
  return "/\(index + 1)"
}

private func partFilenameSuffix(_ index: Int?) -> String {
  guard let index = index else { return "" }
  return "--pt\(index + 1)"
}

private func partLogPathSuffix(_ index: Int?) -> String {
  guard let index = index else { return "" }
  return "/\(index + 1)"
}

private func qualityFilenameSuffix(_ quality: DownloadFormat.Audio.Quality) -> String {
  switch quality {
    case .high:
      return ""
    case .low:
      return "--lq"
  }
}

private func qualityLogPathSuffix(_ quality: DownloadFormat.Audio.Quality) -> String {
  switch quality {
    case .high:
      return "/hq"
    case .low:
      return "/lq"
  }
}
