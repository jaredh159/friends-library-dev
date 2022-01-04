import Fluent
import XCTVapor
import XCTVaporUtils

@testable import App

final class ArtifactProductionVersionResolverTests: AppTestCase {

  func testGetLatestRevision() async throws {
    let older = ArtifactProductionVersion.mockOld
    older.version = .init(rawValue: UUID().uuidString)
    _ = try await Current.db.createArtifactProductionVersion(older)

    let latest = ArtifactProductionVersion.mock
    latest.version = .init(rawValue: UUID().uuidString)
    _ = try await Current.db.createArtifactProductionVersion(latest)

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

  func skip_testCreateArtifactProductionVersion() throws {
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
