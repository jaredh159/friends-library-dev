import Foundation
import Graphiti
import NonEmpty

extension EditionImpression {
  struct Files: Codable {
    struct File: Codable {
      let path: String
      let filename: String
      let url: URL

      init(_ directoryPath: String, _ filename: String) {
        let path = directoryPath + "/" + filename
        self.path = path
        self.filename = filename
        url = URL(string: "\(Env.CLOUD_STORAGE_BUCKET_URL)/\(path)")!
      }
    }

    let epub: File
    let mobi: File
    let webPdf: File
    let speech: File
    let appEbook: File
    let paperbackInterior: NonEmpty<[File]>
    let paperbackCover: NonEmpty<[File]>
  }

  var files: Files {
    let edition = edition.require()
    let path = edition.directoryPath
    let filenameBase = edition.filename

    var interiors = paperbackVolumes.enumerated().map { index, _ -> Files.File in
      let suffix = paperbackVolumes.count == 1 ? "" : "--v\(index + 1)"
      return Files.File(path, "\(filenameBase)--(print)\(suffix).pdf")
    }

    var covers = paperbackVolumes.enumerated().map { index, _ -> Files.File in
      let suffix = paperbackVolumes.count == 1 ? "" : "--v\(index + 1)"
      return Files.File(path, "\(filenameBase)--cover\(suffix).pdf")
    }

    return Files(
      epub: .init(path, filenameBase + ".epub"),
      mobi: .init(path, filenameBase + ".mobi"),
      webPdf: .init(path, filenameBase + ".pdf"),
      speech: .init(path, filenameBase + ".html"),
      appEbook: .init(path, filenameBase + "--(app-ebook).html"),
      paperbackInterior: .init(interiors.removeFirst()) + interiors,
      paperbackCover: .init(covers.removeFirst()) + covers
    )
  }
}

// extensions

extension AppSchema {
  static var EditionImpressionFileType: AppType<EditionImpression.Files.File> {
    Type(EditionImpression.Files.File.self, as: "EditionImpressionFile") {
      Field("path", at: \.path)
      Field("filename", at: \.filename)
      Field("url", at: \.url.absoluteString)
    }
  }

  static var EditionImpressionFilesType: AppType<EditionImpression.Files> {
    Type(EditionImpression.Files.self, as: "EditionImpressionFiles") {
      Field("epub", at: \.epub)
      Field("mobi", at: \.mobi)
      Field("webPdf", at: \.webPdf)
      Field("speech", at: \.speech)
      Field("appEbook", at: \.appEbook)
      Field("paperbackInterior", at: \.paperbackInterior.rawValue)
      Field("paperbackCover", at: \.paperbackCover.rawValue)
    }
  }
}
