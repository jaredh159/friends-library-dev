import Foundation
import XCTest

@testable import App

final class DownloadableFileTests: AppTestCase {
  var entities: Entities?
  var impression: EditionImpression { entities!.editionImpression }
  var edition: Edition { entities!.edition }
  var cloudUrl: String { Env.CLOUD_STORAGE_BUCKET_URL }

  override func setUp() {
    super.setUp()
    guard entities == nil else { return }
    sync { [self] in
      entities = await Entities.create {
        $0.edition.type = .updated
        $0.document.filename = "Journal"
      }
    }
  }

  func testLogPaths() {
    let tests: [(DownloadFormat, String)] = [
      (.ebook(.epub), "ebook/epub"),
      (.ebook(.mobi), "ebook/mobi"),
      (.ebook(.pdf), "ebook/pdf"),
      (.ebook(.speech), "ebook/speech"),
      (.ebook(.app), "ebook/app"),
      (.paperback(type: .interior, volumeIndex: nil), "paperback/interior"),
      (.paperback(type: .interior, volumeIndex: 0), "paperback/interior/1"),
      (.paperback(type: .cover, volumeIndex: nil), "paperback/cover"),
      (.paperback(type: .cover, volumeIndex: 0), "paperback/cover/1"),
      (.audio(.m4b(.high)), "audio/m4b/hq"),
      (.audio(.m4b(.low)), "audio/m4b/lq"),
      (.audio(.mp3Zip(.high)), "audio/mp3s/hq"),
      (.audio(.mp3Zip(.low)), "audio/mp3s/lq"),
      (.audio(.mp3(quality: .high, multipartIndex: nil)), "audio/mp3/hq"),
      (.audio(.mp3(quality: .low, multipartIndex: nil)), "audio/mp3/lq"),
      (.audio(.mp3(quality: .high, multipartIndex: 0)), "audio/mp3/1/hq"),
      (.audio(.mp3(quality: .low, multipartIndex: 0)), "audio/mp3/1/lq"),
      (.audio(.podcast(.high)), "audio/podcast/hq/podcast.rss"),
      (.audio(.podcast(.low)), "audio/podcast/lq/podcast.rss"),
    ]

    for (format, pathEnd) in tests {
      let downloadable = DownloadableFile(editionImpression: impression, format: format)
      XCTAssertEqual(downloadable.logPath, "download/\(edition.id.lowercased)/\(pathEnd)")
      XCTAssertEqual(downloadable.logUrl.absoluteString, "\(cloudUrl)/\(downloadable.logPath)")
    }
  }

  func testSourcePath() {
    let file = DownloadableFile(editionImpression: impression, format: .ebook(.epub))
    XCTAssertEqual(file.sourcePath, "\(edition.directoryPath)/Journal--updated.epub")
  }

  func testFilenames() {
    let tests: [(DownloadFormat, String)] = [
      (.ebook(.epub), "Journal--updated.epub"),
      (.ebook(.mobi), "Journal--updated.mobi"),
      (.ebook(.pdf), "Journal--updated.pdf"),
      (.ebook(.speech), "Journal--updated.html"),
      (.ebook(.app), "Journal--updated--(app-ebook).html"),
      (.paperback(type: .interior, volumeIndex: nil), "Journal--updated--(print).pdf"),
      (.paperback(type: .interior, volumeIndex: 0), "Journal--updated--(print)--v1.pdf"),
      (.paperback(type: .cover, volumeIndex: nil), "Journal--updated--cover.pdf"),
      (.paperback(type: .cover, volumeIndex: 0), "Journal--updated--cover--v1.pdf"),
      (.audio(.m4b(.high)), "Journal--updated.m4b"),
      (.audio(.m4b(.low)), "Journal--updated--lq.m4b"),
      (.audio(.mp3Zip(.high)), "Journal--updated--mp3s.zip"),
      (.audio(.mp3Zip(.low)), "Journal--updated--mp3s--lq.zip"),
      (.audio(.mp3(quality: .high, multipartIndex: nil)), "Journal--updated.mp3"),
      (.audio(.mp3(quality: .low, multipartIndex: nil)), "Journal--updated--lq.mp3"),
      (.audio(.mp3(quality: .high, multipartIndex: 0)), "Journal--updated--pt1.mp3"),
      (.audio(.mp3(quality: .low, multipartIndex: 0)), "Journal--updated--pt1--lq.mp3"),
      (.audio(.podcast(.high)), "podcast.rss"),
      (.audio(.podcast(.low)), "podcast.rss"),
    ]

    for (format, expectedFilename) in tests {
      let downloadable = DownloadableFile(editionImpression: impression, format: format)
      XCTAssertEqual(downloadable.filename, expectedFilename)
      XCTAssertEqual(
        downloadable.sourceUrl.absoluteString,
        "\(cloudUrl)/\(edition.directoryPath)/\(expectedFilename)"
      )
    }
  }
}
