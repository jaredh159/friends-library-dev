import Vapor
import XCTest

@testable import App

final class ArtifactProductionVersionRepositoryTests: AppTestCase {

  func testCreateVersionAndRetrieveLatest() {
    let older = ArtifactProductionVersion.mockOld
    _ = try! Current.db.createArtifactProductionVersion(older).wait()

    let latest = ArtifactProductionVersion.mock
    _ = try! Current.db.createArtifactProductionVersion(latest).wait()
    let retrieved = try! Current.db.getLatestArtifactProductionVersion().wait()

    XCTAssertEqual(retrieved, latest)
  }
}
