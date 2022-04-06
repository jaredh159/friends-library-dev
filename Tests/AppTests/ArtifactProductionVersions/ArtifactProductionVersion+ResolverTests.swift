import XCTest

@testable import App

final class ArtifactProductionVersionResolverTests: AppTestCase {

  func testGetLatestRevision() async throws {
    let older = ArtifactProductionVersion.mockOld
    older.version = .init(rawValue: UUID().uuidString)
    try await Current.db.create(older)

    let latest = ArtifactProductionVersion.mock
    latest.version = .init(rawValue: UUID().uuidString)
    try await Current.db.create(latest)

    assertResponse(
      to: /* gql */ """
      query GetLatestArtifactProductionVersion {
        version: getLatestArtifactProductionVersion {
          id
          sha: version
        }
      }
      """,
      .containsKeyValuePairs([
        "id": latest.id.lowercased,
        "sha": latest.version,
      ])
    )
  }

  func testCreateArtifactProductionVersion() throws {
    let revision = UUID().uuidString

    assertResponse(
      to: /* gql */ """
      mutation CreateArtifactProductionVersion($input: CreateArtifactProductionVersionInput!) {
        version: createArtifactProductionVersion(input: $input) {
          sha: version
        }
      }
      """,
      bearer: Seeded.tokens.mutateArtifactProductionVersions,
      withVariables: ["input": .dictionary(["version": .string(revision)])],
      .containsKeyValuePairs(["sha": revision])
    )
  }
}
