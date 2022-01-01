import GraphQL
import XCTVapor
import XCTVaporUtils

@testable import App

final class DownloadResolverTests: AppTestCase {

  // @TODO after all FK things
  func testCreateDownload() throws {
    XCTAssertEqual(true, true)
  }

  func skip_actualTest() throws {
    let oldDb = Current.db
    Current.db = .mock
    let edition = Edition.random
    // try await Current.db.create
    let insert = Download.random
    insert.editionId = edition.id

    GraphQLTest(
      """
      mutation CreateDownload($input: CreateDownloadInput!) {
        download: createDownload(input: $input) {
          edition {
            id
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
        "documentId": "853E4E56-7A46-44A2-B689-B48458B588B0",
        "editionType": "updated",
        "format": "mp3",
        "source": "website",
        "isMobile": true,
        "audioQuality": "lq",
        "audioPartNumber": 2,
        "userAgent": "Brave Browser",
        "os": "Mac",
        "browser": "Brave",
        "platform": "not sure",
        "referrer": "rad-link",
        "ip": "1.2.3.4",
        "city": "Wadsworth",
        "region": "OH",
        "postalCode": "44281",
        "country": "US",
        "latitude": "6",
        "longitude": "7",
      ]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": insert.gqlMap()])

    Current.db = oldDb
  }
}
