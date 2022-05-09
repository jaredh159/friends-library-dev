import XCTVapor

@testable import App

final class AudioResolverTests: AppTestCase {

  func testCreateAudio() async throws {
    let entities = await Entities.create()
    _ = try await Current.db.delete(entities.audio.id)
    let audio = Audio.valid
    audio.editionId = entities.edition.id
    let map = audio.gqlMap()

    assertResponse(
      to: /* gql */ """
      mutation CreateAudio($input: CreateAudioInput!) {
        audio: createAudio(input: $input) {
          id
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": map],
      .containsKeyValuePairs(["id": map["id"]])
    )
  }

  func testGetAudio() async throws {
    let entities = await Entities.create()
    let audio = entities.audio

    assertResponse(
      to: /* gql */ """
      query GetAudio {
        audio: getAudio(id: "\(audio.id.uuidString)") {
          id
          files {
            podcast {
              hq {
                logPath
              }
            }
          }
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      .containsKeyValuePairs([
        "id": audio.id.lowercased,
        "logPath": DownloadableFile(
          edition: entities.edition,
          format: .audio(.podcast(.high))
        )
        .logPath
        .replacingOccurrences(of: "/", with: "\\/"),
      ])
    )
  }

  func testUpdateAudio() async throws {
    let audio = await Entities.create().audio

    // do some updates here ---vvv
    audio.reader = "new value"

    assertResponse(
      to: /* gql */ """
      mutation UpdateAudio($input: UpdateAudioInput!) {
        audio: updateAudio(input: $input) {
          reader
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": audio.gqlMap()],
      .containsKeyValuePairs(["reader": "new value"])
    )
  }

  func testDeleteAudio() async throws {
    let audio = await Entities.create().audio

    assertResponse(
      to: /* gql */ """
      mutation DeleteAudio {
        audio: deleteAudio(id: "\(audio.id.uuidString)") {
          id
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": audio.gqlMap()],
      .containsKeyValuePairs(["id": audio.id.lowercased])
    )

    let retrieved = try? await Current.db.find(audio.id)
    XCTAssertNil(retrieved)
  }
}
