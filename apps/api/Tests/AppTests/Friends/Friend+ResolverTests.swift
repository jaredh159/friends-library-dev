import XCTest

@testable import App

final class FriendResolverTests: AppTestCase {

  func testCreateFriend() async throws {
    let friend = Friend.valid
    let map = friend.gqlMap()

    assertResponse(
      to: /* gql */ """
      mutation CreateFriend($input: CreateFriendInput!) {
        friend: createFriend(input: $input) {
          id
          documents {
            id
          }
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": map],
      .containsKeyValuePairs(["id": map["id"]])
    )
  }

  func testGetFriend() async throws {
    let entities = await Entities.create()

    let query = /* gql */ """
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
          trimmedUtf8ShortTitle
          friend {
            documentFriendId: id
          }
          tags {
            tagId: id
            document {
              documentTagDocumentId: id
            }
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

    assertResponse(
      to: query,
      .containsKeyValuePairs([
        "id": entities.friend.id.lowercased,
        "quoteId": entities.friendQuote.id.lowercased,
        "tagId": entities.documentTag.id.lowercased,
        "documentTagDocumentId": entities.document.id.lowercased,
        "quoteFriendId": entities.friend.id.lowercased,
        "friendResidenceFriendId": entities.friend.id.lowercased,
        "documentFriendId": entities.friend.id.lowercased,
        "city": entities.friendResidence.city,
        "residenceDurationResidenceId": entities.friendResidence.id.lowercased,
        "editionId": entities.edition.id.lowercased,
        "chapterEditionId": entities.edition.id.lowercased,
        "audioEditionId": entities.edition.id.lowercased,
        "isbnEditionId": entities.edition.id.lowercased,
        "editionImpressionEditionId": entities.edition.id.lowercased,
        "editionImpressionId": entities.editionImpression.id.lowercased,
        "documentId": entities.document.id.lowercased,
        "editionDocumentId": entities.document.id.lowercased,
        "reader": entities.audio.reader,
        "audioPartAudioId": entities.audio.id.lowercased,
        "audioPartTitle": entities.audioPart.title,
        "isbnCode": entities.isbn.code.rawValue,
        "trimmedUtf8ShortTitle": entities.document.title,
      ])
    )
  }

  func testUpdateFriend() async throws {
    let friend = try await Current.db.create(Friend.valid)

    // do some updates here ---vvv
    friend.name = "Bob"

    assertResponse(
      to: /* gql */ """
      mutation UpdateFriend($input: UpdateFriendInput!) {
        friend: updateFriend(input: $input) {
          name
        }
      }
      """,
      withVariables: ["input": friend.gqlMap()],
      .containsKeyValuePairs(["name": "Bob"])
    )
  }

  func testDeleteFriend() async throws {
    let friend = try await Current.db.create(Friend.random)

    assertResponse(
      to: /* gql */ """
      mutation DeleteFriend {
        friend: deleteFriend(id: "\(friend.id.uuidString)") {
          id
        }
      }
      """,
      withVariables: ["input": friend.gqlMap()],
      .containsKeyValuePairs(["id": friend.id.lowercased])
    )

    let retrieved = try? await Current.db.find(friend.id)
    XCTAssertNil(retrieved)
  }
}
