import Fluent
// import GraphQlKit
import XCTVapor
import XCTVaporUtils

@testable import App

final class ArtifactProductionVersionResolverTests: AppTestCase {

  func testGetLatestRevision() throws {
    let older = ArtifactProductionVersion.mockOld
    _ = try! Current.db.createArtifactProductionVersion(older).wait()

    let latest = ArtifactProductionVersion.mock
    _ = try! Current.db.createArtifactProductionVersion(latest).wait()

    GraphQLTest(
      """
      query GetLatestArtifactProductionVersion {
        version: getLatestArtifactProductionVersion {
          id
          sha: version
        }
      }
      """,
      expectedData: .containsKVPs([
        "id": latest.id.rawValue.uuidString,
        "sha": latest.version,
      ])
    ).run(Self.app)
  }

  func testCreateArtifactProductionVersion() throws {
    let revision = UUID().uuidString

    GraphQLTest(
      """
      mutation CreateArtifactProductionVersion($revision: String!) {
        version: createArtifactProductionVersion(revision: $revision) {
          sha: version
        }
      }
      """,
      expectedData: .containsKVPs(["sha": revision]),
      headers: [.authorization: "Bearer \(Seeded.tokens.mutateArtifactProductionVersions)"]
    ).run(Self.app, variables: ["revision": .string(revision)])
  }
}
