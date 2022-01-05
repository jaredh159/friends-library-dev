import XCTVapor
import XCTVaporUtils

@testable import App

final class FriendResolverTests: AppTestCase {

  func testCreateFriend() async throws {
    let friend = Friend.random
    let map = friend.gqlMap()

    GraphQLTest(
      """
      mutation CreateFriend($input: CreateFriendInput!) {
        download: createFriend(input: $input) {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": map["id"]]),
      headers: [.authorization: "Bearer (Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": map])
  }

  func testGetFriend() async throws {
    let entities = await Entities.create()

    let query = """
      query GetFriend {
        friend: getFriend(id: "\(entities.friend.id.uuidString)") {
          id
          quotes {
            quoteId: id
            friend {
              quoteFriendId: id
            }
          }
          residences {
            city
            durations {
              id
              residence {
                residenceDurationResidenceId: id
              }
            }
            friend {
              friendResidenceFriendId: id
            }
          }
          documents {
            documentId: id
            friend {
              documentFriendId: id
            }
            editions {
              editionId: id
              impression {
                editionImpressionId: id
                edition {
                  editionImpressionEditionId: id
                }
              }
              chapters {
                chapterId: id
                edition {
                  chapterEditionId: id
                }
              }
              document {
                editionDocumentId: id
              }
              isbn {
                isbnCode: code
                edition {
                  isbnEditionId: id
                }
              }
              audio {
                edition {
                  audioEditionId: id
                }
                reader
                parts {
                  audioPartTitle: title
                  audio {
                    audioPartAudioId: id
                  }
                }
              }
            }
          }
        }
      }
      """

    let expectedData = GraphQLTest.ExpectedData.containsKVPs([
      "id": entities.friend.id.uuidString,
      "quoteId": entities.friendQuote.id.uuidString,
      "quoteFriendId": entities.friend.id,
      "friendResidenceFriendId": entities.friend.id.uuidString,
      "documentFriendId": entities.friend.id.uuidString,
      "city": entities.friendResidence.city,
      "residenceDurationResidenceId": entities.friendResidence.id.uuidString,
      "editionId": entities.edition.id.uuidString,
      "chapterEditionId": entities.edition.id.uuidString,
      "audioEditionId": entities.edition.id.uuidString,
      "isbnEditionId": entities.edition.id.uuidString,
      "editionImpressionEditionId": entities.edition.id.uuidString,
      "editionImpressionId": entities.editionImpression.id.uuidString,
      "documentId": entities.document.id.uuidString,
      "editionDocumentId": entities.document.id.uuidString,
      "reader": entities.audio.reader,
      "audioPartAudioId": entities.audio.id.uuidString,
      "audioPartTitle": entities.audioPart.title,
      "isbnCode": entities.isbn.code.rawValue,
    ])

    GraphQLTest(
      query,
      expectedData: expectedData,
      headers: [.authorization: "Bearer (Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateFriend() async throws {
    let friend = try await Current.db.createFriend(.random)

    // do some updates here ---vvv
    friend.name = "Bob"

    GraphQLTest(
      """
      mutation UpdateFriend($input: UpdateFriendInput!) {
        friend: updateFriend(input: $input) {
          name
        }
      }
      """,
      expectedData: .containsKVPs(["name": "Bob"]),
      headers: [.authorization: "Bearer (Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": friend.gqlMap()])
  }

  func testDeleteFriend() async throws {
    let friend = try await Current.db.createFriend(.random)

    GraphQLTest(
      """
      mutation DeleteFriend {
        friend: deleteFriend(id: "\(friend.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": friend.id.uuidString]),
      headers: [.authorization: "Bearer (Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": friend.gqlMap()])

    let retrieved = try? await Current.db.getFriend(friend.id)
    XCTAssertNil(retrieved)
  }
}
