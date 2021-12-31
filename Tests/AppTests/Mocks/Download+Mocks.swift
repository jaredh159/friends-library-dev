// auto-generated, do not edit
@testable import App

extension Download {
  static var mock: Download {
    Download(
      documentId: .init(),
      editionType: .updated,
      format: .epub,
      source: .website,
      isMobile: true
    )
  }

  static var empty: Download {
    Download(
      documentId: .init(),
      editionType: .updated,
      format: .epub,
      source: .website,
      isMobile: false
    )
  }

  static var random: Download {
    Download(
      documentId: .init(),
      editionType: EditionType.allCases.shuffled().first!,
      format: Format.allCases.shuffled().first!,
      source: DownloadSource.allCases.shuffled().first!,
      isMobile: Bool.random()
    )
  }
}
