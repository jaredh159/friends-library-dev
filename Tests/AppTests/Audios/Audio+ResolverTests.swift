import XCTVapor
import XCTVaporUtils

@testable import App

final class AudioResolverTests: AppTestCase {

  func testCreateAudio() async throws {
    let entities = await Entities.create()
    _ = try await Current.db.deleteAudio(entities.audio.id)
    let audio = Audio.random
    audio.editionId = entities.edition.id
    let map = audio.gqlMap()

    GraphQLTest(
      """
      mutation CreateAudio($input: CreateAudioInput!) {
        download: createAudio(input: $input) {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": map["id"]]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": map])
  }

  func testGetAudio() async throws {
    let audio = await Entities.create().audio

    GraphQLTest(
      """
      query GetAudio {
        audio: getAudio(id: "\(audio.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": audio.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateAudio() async throws {
    let audio = await Entities.create().audio

    // do some updates here ---vvv
    audio.reader = "new value"

    GraphQLTest(
      """
      mutation UpdateAudio($input: UpdateAudioInput!) {
        audio: updateAudio(input: $input) {
          reader
        }
      }
      """,
      expectedData: .containsKVPs(["reader": "new value"]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": audio.gqlMap()])
  }

  func testDeleteAudio() async throws {
    let audio = await Entities.create().audio

    GraphQLTest(
      """
      mutation DeleteAudio {
        audio: deleteAudio(id: "\(audio.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": audio.id.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": audio.gqlMap()])

    let retrieved = try? await Current.db.getAudio(audio.id)
    XCTAssertNil(retrieved)
  }
}
