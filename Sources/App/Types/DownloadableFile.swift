import Foundation

struct DownloadableFile {
  let filename: String
  let sourcePath: String
  let sourceUrl: URL
  let logPath: String
  let logUrl: URL

  init(editionImpression impression: EditionImpression, format: DownloadFormat) {
    let edition = impression.edition.require()
    filename = deriveFilename(base: edition.filename, format: format)
    sourcePath = "\(edition.directoryPath)/\(filename)"
    sourceUrl = URL(string: "\(Env.CLOUD_STORAGE_BUCKET_URL)/\(sourcePath)")!
    logPath = deriveLogPath(editionId: edition.id, format: format)
    logUrl = URL(string: "\(Env.CLOUD_STORAGE_BUCKET_URL)/\(logPath)")!
  }
}

// helpers

private func deriveLogPath(editionId: Edition.Id, format: DownloadFormat) -> String {
  let id = editionId.lowercased
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

private func deriveFilename(base: String, format: DownloadFormat) -> String {
  switch format {
    case .ebook(.epub):
      return "\(base).epub"
    case .ebook(.mobi):
      return "\(base).mobi"
    case .ebook(.pdf):
      return "\(base).pdf"
    case .ebook(.speech):
      return "\(base).html"
    case .ebook(.app):
      return "\(base)--(app-ebook).html"
    case .paperback(.interior, let index):
      return "\(base)--(print)\(index |> volumeFilenameSuffix).pdf"
    case .paperback(.cover, let index):
      return "\(base)--cover\(index |> volumeFilenameSuffix).pdf"
    case .audio(.m4b(let quality)):
      return "\(base)\(quality |> qualityFilenameSuffix).m4b"
    case .audio(.mp3Zip(let quality)):
      return "\(base)--mp3s\(quality |> qualityFilenameSuffix).zip"
    case .audio(.mp3(let quality, let index)):
      return "\(base)\(index |> partFilenameSuffix)\(quality |> qualityFilenameSuffix).mp3"
    case .audio(.podcast):
      return "podcast.rss"
  }
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
