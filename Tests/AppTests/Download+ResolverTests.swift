import XCTVapor
import XCTVaporUtils

@testable import App

final class DownloadResolverTests: GraphQLTestCase {
  override func configureApp(_ app: Application) throws {
    return try configure(app)
  }

  func testCreateDownload() throws {
    GraphQLTest(
      """
      mutation {
        download: createDownload(
          documentId: "853e4e56-7a46-44a2-b689-b48458b588b0"
          editionType: updated
          format: mp3
          source: website
          isMobile: true
          audioQuality: lq
          audioPartNumber: 2
          userAgent: "Brave Browser"
          os: "Mac"
          browser: "Brave"
          platform: "not sure"
          referrer: "rad-link"
          ip: "1.2.3.4"
          city: "Wadsworth"
          region: "OH"
          postalCode: "44281"
          country: "US"
          latitude: "6"
          longitude: "7"
        ) {
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
    ).run(self)
  }
}
