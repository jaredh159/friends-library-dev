@testable import App

extension Download {
  static var mock: Download {
    Download(
      documentId: .init(),
      editionType: .updated,
      format: .epub,
      source: .website,
      isMobile: false
    )
  }
}
