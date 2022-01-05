import GraphQL
import XCTVapor
import XCTVaporUtils

@testable import App

final class DownloadResolverTests: AppTestCase {

  func testCreateDownload() async throws {
    let entities = await Entities.create()
    let insert: Download = .random
    insert.audioQuality = .lq
    insert.audioPartNumber = 33
    insert.editionId = entities.edition.id
    let map = insert.gqlMap()

    GraphQLTest(
      """
      mutation CreateDownload($input: CreateDownloadInput!) {
        download: createDownload(input: $input) {
          edition {
            id
            editionType: type
            document {
              documentId: id
            }
          }
          format
          source
          isMobile
          audioQuality
          audioPartNumber
          userAgent
          os
          browser
          platform
          referrer
          ip
          city
          region
          postalCode
          country
          latitude
          longitude
        }
      }
      """,
      expectedData: .containsKVPs([
        "documentId": entities.document.id.uuidString,
        "editionType": entities.edition.type.rawValue,
        "format": map["format"],
        "source": map["source"],
        "isMobile": map["isMobile"],
        "audioQuality": map["audioQuality"],
        "audioPartNumber": map["audioPartNumber"],
      ]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": insert.gqlMap()])
  }
}
