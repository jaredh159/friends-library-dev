import GraphQL
import XCTVapor
import XCTVaporUtils

@testable import App

final class DownloadResolverTests: AppTestCase {
  func testCreateDownload() throws {
    // temp, until FK issue
    let oldDb = Current.db
    Current.db = .mock(eventLoop: Self.app.eventLoopGroup.next())

    let input: Map = .dictionary([
      "documentId": .string("853e4e56-7a46-44a2-b689-b48458b588b0"),
      "editionType": .string("updated"),
      "format": .string("mp3"),
      "source": .string("website"),
      "isMobile": .bool(true),
      "audioQuality": .string("lq"),
      "audioPartNumber": .number(2),
      "userAgent": .string("Brave Browser"),
      "os": .string("Mac"),
      "browser": .string("Brave"),
      "platform": .string("not sure"),
      "referrer": .string("rad-link"),
      "ip": .string("1.2.3.4"),
      "city": .string("Wadsworth"),
      "region": .string("OH"),
      "postalCode": .string("44281"),
      "country": .string("US"),
      "latitude": .string("6"),
      "longitude": .string("7"),
    ])

    GraphQLTest(
      """
      mutation CreateDownload($input: CreateDownloadInput!) {
        download: createDownload(input: $input) {
          documentId
          editionType
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
    ).run(Self.app, variables: ["input": input])

    Current.db = oldDb
  }
}
