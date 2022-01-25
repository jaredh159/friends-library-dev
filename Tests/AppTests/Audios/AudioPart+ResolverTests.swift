import XCTVapor
import XCTVaporUtils

@testable import App

final class AudioPartResolverTests: AppTestCase {

  func testCreateAudioPart() async throws {
    let entities = await Entities.create()
    let audioPart = AudioPart.random
    audioPart.audioId = entities.audio.id
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
    let audioPart = await Entities.create().audioPart

    GraphQLTest(
      """
      query GetAudioPart {
        audioPart: getAudioPart(id: "\(audioPart.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": audioPart.id.lowercased]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateAudioPart() async throws {
    let audioPart = await Entities.create().audioPart

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
    let audioPart = await Entities.create().audioPart

    GraphQLTest(
      """
      mutation DeleteAudioPart {
        audioPart: deleteAudioPart(id: "\(audioPart.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": audioPart.id.lowercased]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": audioPart.gqlMap()])

    let retrieved = try? await Current.db.find(audioPart.id)
    XCTAssertNil(retrieved)
  }
}
