import XCTest

@testable import App

final class DownloadResolverTests: AppTestCase {

  func testGetDocumentDownloadCounts() async throws {
    try await Current.db.query(Download.self).delete()
    let entities = await Entities.create()
    let download1: Download = .random
    download1.editionId = entities.edition.id
    let download2: Download = .random
    download2.editionId = entities.edition.id
    try await Current.db.create([download1, download2])

    assertResponse(
      to: /* gql */ """
      query GetDocumentDownloadCounts {
        counts: getDocumentDownloadCounts {
          documentId
          downloadCount
        }
      }
      """,
      bearer: Seeded.tokens.allScopes,
      .containsKeyValuePairs([
        "documentId": entities.document.id.lowercased,
        "downloadCount": 2,
      ])
    )
  }

  func testCreateDownload() async throws {
    let entities = await Entities.create()
    let insert: Download = .random
    insert.audioQuality = .lq
    insert.audioPartNumber = 33
    insert.editionId = entities.edition.id
    let map = insert.gqlMap()

    assertResponse(
      to: /* gql */ """
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
      bearer: Seeded.tokens.allScopes,
      withVariables: ["input": insert.gqlMap()],
      .containsKeyValuePairs([
        "documentId": entities.document.id.lowercased,
        "editionType": entities.edition.type.rawValue,
        "format": map["format"],
        "source": map["source"],
        "isMobile": map["isMobile"],
        "audioQuality": map["audioQuality"],
        "audioPartNumber": map["audioPartNumber"],
      ])
    )
  }
}
