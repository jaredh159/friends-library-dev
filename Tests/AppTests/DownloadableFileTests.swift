import Foundation
import Vapor
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
      try await Current.db.deleteAll(Download.self)
      try await Current.db.deleteAll(Friend.self)
      entities = await Entities.create {
        $0.edition.type = .updated
        $0.document.filename = "Journal"
      }
    }
  }

  func testPodcastAgentsIdentifiedAsPodcast() async throws {
    let userAgents = [
      "lol podcasts",
      "Apple Podcasts",
      "Audible Mozilla Lol",
      "overcast more stuff",
      "tunein more stuff",
      "foobar Castro (like Mozilla) more stuff",
      "castbox more stuff",
      "stitcher more stuff",
    ]
    for userAgent in userAgents {
      let file = DownloadableFile(edition: edition, format: .ebook(.epub))
      let res = try await logAndRedirect(file: file, userAgent: userAgent)
      let download = try await Current.db.query(Download.self)
        .where(.userAgent == .string(userAgent))
        .first()
      XCTAssertEqual(download.source, .podcast)
      XCTAssertEqual(res.status, RedirectType.permanent.status)
    }
  }

  func testBotDownload() async throws {
    let botUa = "GoogleBot"
    let file = DownloadableFile(edition: edition, format: .ebook(.epub))
    let res = try await logAndRedirect(file: file, userAgent: botUa)
    let downloads = try await Current.db.query(Download.self)
      .where(.userAgent == .string("GoogleBot"))
      .all()
    XCTAssertEqual([], downloads) // no downloads inserted in db
    XCTAssertEqual(sent.slacks, [.debug("Bot download: `GoogleBot`")])
    XCTAssertEqual(res.headers.first(name: .location), file.sourceUrl.absoluteString)
  }

  func testDownloadHappyPathNoLocationFound() async throws {
    Current.ipApiClient.getIpData = { _ in throw "whoops" }
    let userAgent = "FriendsLibrary".random
    let device = UserAgentDeviceData(userAgent: userAgent)
    let file = DownloadableFile(edition: edition, format: .ebook(.epub))

    let res = try await logAndRedirect(
      file: file,
      userAgent: userAgent,
      ipAddress: "1.2.3.4",
      referrer: "https://www.friendslibrary.com"
    )

    let inserted = try await Current.db.query(Download.self)
      .where(.userAgent == .string(userAgent))
      .first()

    XCTAssertEqual(inserted.editionId, file.edition.id)
    XCTAssertEqual(inserted.format, .epub)
    XCTAssertEqual(inserted.source, .app)
    XCTAssertEqual(inserted.isMobile, device?.isMobile)
    XCTAssertEqual(inserted.os, device?.os)
    XCTAssertEqual(inserted.browser, device?.browser)
    XCTAssertEqual(inserted.platform, device?.platform)
    XCTAssertEqual(inserted.ip, "1.2.3.4")
    XCTAssertEqual(inserted.referrer, "https://www.friendslibrary.com")
    XCTAssertEqual(inserted.audioQuality, nil)
    XCTAssertEqual(inserted.audioPartNumber, nil)
    XCTAssertEqual(res.headers.first(name: .location), file.sourceUrl.absoluteString)
  }

  func testDownloadHappyPathLocationFound() async throws {
    Current.ipApiClient.getIpData = { ip in
      XCTAssertEqual(ip, "1.2.3.4")
      return .init(
        ip: ip,
        city: "City",
        region: "Region",
        countryName: "CountryName",
        postal: "Postal",
        latitude: 123.456,
        longitude: -123.456
      )
    }

    let userAgent = "Netscape 3.0".random
    let file = DownloadableFile(
      edition: edition,
      format: .audio(.mp3(quality: .high, multipartIndex: 3))
    )

    _ = try await logAndRedirect(
      file: file,
      userAgent: userAgent,
      ipAddress: "1.2.3.4",
      referrer: "https://www.friendslibrary.com"
    )

    let inserted = try await Current.db.query(Download.self)
      .where(.userAgent == .string(userAgent))
      .first()

    XCTAssertEqual(inserted.city, "City")
    XCTAssertEqual(inserted.region, "Region")
    XCTAssertEqual(inserted.postalCode, "Postal")
    XCTAssertEqual(inserted.latitude, "123.456")
    XCTAssertEqual(inserted.longitude, "-123.456")
    XCTAssertEqual(sent.slacks.count, 1)
    XCTAssertEqual(sent.slacks[0].channel, .audioDownloads)
    XCTAssertEqual(
      sent.slacks[0].text,
      "Download: `\(edition.directoryPath)`, device: `non-mobile`, from url: `[friendslibrary.com]`, location: `City / Region / Postal / CountryName` https://www.google.com/maps/@123.456,-123.456,14z"
    )
  }

  func testAppUaIsNotCountedAsBot() async throws {
    let userAgent = "FriendsLibrary GoogleBot".random
    let file = DownloadableFile(edition: edition, format: .ebook(.epub))
    _ = try await logAndRedirect(file: file, userAgent: userAgent)

    let inserted = try await Current.db.query(Download.self)
      .where(.userAgent == .string(userAgent))
      .first()

    XCTAssertEqual(inserted.editionId, edition.id)
  }

  func testInitFromLogPath() async throws {
    let tests: [(String, DownloadableFile.Format)] = [
      ("ebook/epub", .ebook(.epub)),
      ("ebook/mobi", .ebook(.mobi)),
      ("ebook/pdf", .ebook(.pdf)),
      ("ebook/speech", .ebook(.speech)),
      ("ebook/app", .ebook(.app)),
      ("paperback/interior", .paperback(type: .interior, volumeIndex: nil)),
      ("paperback/interior/1", .paperback(type: .interior, volumeIndex: 0)),
      ("paperback/cover", .paperback(type: .cover, volumeIndex: nil)),
      ("paperback/cover/1", .paperback(type: .cover, volumeIndex: 0)),
      ("audio/m4b/hq", .audio(.m4b(.high))),
      ("audio/m4b/lq", .audio(.m4b(.low))),
      ("audio/mp3s/hq", .audio(.mp3s(.high))),
      ("audio/mp3s/lq", .audio(.mp3s(.low))),
      ("audio/mp3/hq", .audio(.mp3(quality: .high, multipartIndex: nil))),
      ("audio/mp3/lq", .audio(.mp3(quality: .low, multipartIndex: nil))),
      ("audio/mp3/1/hq", .audio(.mp3(quality: .high, multipartIndex: 0))),
      ("audio/mp3/1/lq", .audio(.mp3(quality: .low, multipartIndex: 0))),
      ("audio/podcast/hq/podcast.rss", .audio(.podcast(.high))),
      ("audio/podcast/lq/podcast.rss", .audio(.podcast(.low))),
    ]

    for (pathEnd, format) in tests {
      let logPath = "download/\(edition.id.lowercased)/\(pathEnd)"
      let downloadable = try await DownloadableFile(logPath: logPath)
      XCTAssertEqual(edition, downloadable.edition)
      XCTAssertEqual(format, downloadable.format)
    }
  }

  func testLogPaths() {
    let tests: [(DownloadableFile.Format, String)] = [
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
      (.audio(.mp3s(.high)), "audio/mp3s/hq"),
      (.audio(.mp3s(.low)), "audio/mp3s/lq"),
      (.audio(.mp3(quality: .high, multipartIndex: nil)), "audio/mp3/hq"),
      (.audio(.mp3(quality: .low, multipartIndex: nil)), "audio/mp3/lq"),
      (.audio(.mp3(quality: .high, multipartIndex: 0)), "audio/mp3/1/hq"),
      (.audio(.mp3(quality: .low, multipartIndex: 0)), "audio/mp3/1/lq"),
      (.audio(.podcast(.high)), "audio/podcast/hq/podcast.rss"),
      (.audio(.podcast(.low)), "audio/podcast/lq/podcast.rss"),
    ]

    for (format, pathEnd) in tests {
      let downloadable = DownloadableFile(edition: edition, format: format)
      XCTAssertEqual(downloadable.logPath, "download/\(edition.id.lowercased)/\(pathEnd)")
      XCTAssertEqual(downloadable.logUrl.absoluteString, "\(cloudUrl)/\(downloadable.logPath)")
    }
  }

  func testSourcePath() {
    let file = DownloadableFile(edition: edition, format: .ebook(.epub))
    XCTAssertEqual(file.sourcePath, "\(edition.directoryPath)/Journal--updated.epub")
  }

  func testFilenames() {
    let tests: [(DownloadableFile.Format, String)] = [
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
      (.audio(.mp3s(.high)), "Journal--updated--mp3s.zip"),
      (.audio(.mp3s(.low)), "Journal--updated--mp3s--lq.zip"),
      (.audio(.mp3(quality: .high, multipartIndex: nil)), "Journal--updated.mp3"),
      (.audio(.mp3(quality: .low, multipartIndex: nil)), "Journal--updated--lq.mp3"),
      (.audio(.mp3(quality: .high, multipartIndex: 0)), "Journal--updated--pt1.mp3"),
      (.audio(.mp3(quality: .low, multipartIndex: 0)), "Journal--updated--pt1--lq.mp3"),
      (.audio(.podcast(.high)), "podcast.rss"),
      (.audio(.podcast(.low)), "podcast.rss"),
    ]

    for (format, expectedFilename) in tests {
      let downloadable = DownloadableFile(edition: edition, format: format)
      XCTAssertEqual(downloadable.filename, expectedFilename)
      XCTAssertEqual(
        downloadable.sourceUrl.absoluteString,
        "\(cloudUrl)/\(edition.directoryPath)/\(expectedFilename)"
      )
    }
  }
}
