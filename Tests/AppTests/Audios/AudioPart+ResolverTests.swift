import XCTVapor
import XCTVaporUtils

@testable import App

final class AudioPartResolverTests: AppTestCase {

  func testCreateAudioPart() async throws {
    let audioPart = AudioPart.random
    let map = audioPart.gqlMap()

    GraphQLTest(
      """
      mutation CreateAudioPart($input: CreateAudioPartInput!) {
        download: createAudioPart(input: $input) {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": map["id"]]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": map])
  }

  func testGetAudioPart() async throws {
    let audioPart = try await Current.db.createAudioPart(.random)

    GraphQLTest(
      """
      query GetAudioPart {
        audioPart: getAudioPart(id: "\(audioPart.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": audioPart.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateAudioPart() async throws {
    let audioPart = try await Current.db.createAudioPart(.random)

    // do some updates here ---vvv
    audioPart.title = "new value"

    GraphQLTest(
      """
      mutation UpdateAudioPart($input: UpdateAudioPartInput!) {
        audioPart: updateAudioPart(input: $input) {
          title
        }
      }
      """,
      expectedData: .containsKVPs(["title": "new value"]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": audioPart.gqlMap()])
  }

  func testDeleteAudioPart() async throws {
    let audioPart = try await Current.db.createAudioPart(.random)

    GraphQLTest(
      """
      mutation DeleteAudioPart {
        audioPart: deleteAudioPart(id: "\(audioPart.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": audioPart.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": audioPart.gqlMap()])

    let retrieved = try? await Current.db.getAudioPart(audioPart.id)
    XCTAssertNil(retrieved)
  }
}
