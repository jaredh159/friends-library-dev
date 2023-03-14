import XCTest

@testable import App

final class AudioPartResolverTests: AppTestCase {

  func testCreateAudioPart() async throws {
    let entities = await Entities.create()
    let audioPart = AudioPart.valid
    audioPart.audioId = entities.audio.id
    let map = audioPart.gqlMap()

    assertResponse(
      to: /* gql */ """
      mutation CreateAudioPart($input: CreateAudioPartInput!) {
        part: createAudioPart(input: $input) {
          id
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": map],
      .containsKeyValuePairs(["id": map["id"]])
    )
  }

  func testGetAudioPart() async throws {
    try await Current.db.deleteAll(Audio.self)
    let entities = await Entities.create()
    let audioPart = entities.audioPart

    assertResponse(
      to: /* gql */ """
      query GetAudioPart {
        audioPart: getAudioPart(id: "\(audioPart.id.uuidString)") {
          id
          mp3File {
            hq {
              logPath
            }
          }
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      .containsKeyValuePairs([
        "id": audioPart.id.lowercased,
        "logPath": DownloadableFile(
          edition: entities.edition,
          format: .audio(.mp3(quality: .high, multipartIndex: nil))
        )
        .logPath
        .replacingOccurrences(of: "/", with: "\\/"),
      ])
    )
  }

  func testUpdateAudioPart() async throws {
    let audioPart = await Entities.create().audioPart

    // do some updates here ---vvv
    audioPart.title = "new value"

    assertResponse(
      to: /* gql */ """
      mutation UpdateAudioPart($input: UpdateAudioPartInput!) {
        audioPart: updateAudioPart(input: $input) {
          title
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": audioPart.gqlMap()],
      .containsKeyValuePairs(["title": "new value"])
    )
  }

  func testDeleteAudioPart() async throws {
    let audioPart = await Entities.create().audioPart

    assertResponse(
      to: /* gql */ """
      mutation DeleteAudioPart {
        audioPart: deleteAudioPart(id: "\(audioPart.id.uuidString)") {
          id
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": audioPart.gqlMap()],
      .containsKeyValuePairs(["id": audioPart.id.lowercased])
    )

    let retrieved = try? await Current.db.find(audioPart.id)
    XCTAssertNil(retrieved)
  }
}
