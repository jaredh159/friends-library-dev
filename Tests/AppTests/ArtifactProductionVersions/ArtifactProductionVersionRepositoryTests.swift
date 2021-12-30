import Vapor
import XCTest

@testable import App

final class ArtifactProductionVersionRepositoryTests: AppTestCase {

  func testCreateVersionAndRetrieveLatest() async throws {
    let older = ArtifactProductionVersion.mockOld
    older.version = .init(rawValue: UUID().uuidString)
    try await Current.db.createArtifactProductionVersion(older)

    let latest = ArtifactProductionVersion.mock
    latest.version = .init(rawValue: UUID().uuidString)
    try await Current.db.createArtifactProductionVersion(latest)
    let retrieved = try await Current.db.getLatestArtifactProductionVersion()

    XCTAssertEqual(retrieved, latest)
  }
}
