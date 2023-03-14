import GraphQL
import XCTest

@testable import App

final class FreeOrderRequestResolverTests: AppTestCase {

  func testQueryFreeOrder() async throws {
    let request = try await Current.db.create(FreeOrderRequest.mock)

    assertResponse(
      to: /* gql */ """
      query {
        request: getFreeOrderRequest(id: "\(request.id.uuidString)") {
          email
          name
          requestedBooks
          aboutRequester
          addressStreet
          addressCity
          addressState
          addressZip
          addressCountry
          source
        }
      }
      """,
      .containsKeyValuePairs([
        "email": request.email,
        "name": request.name,
        "requestedBooks": request.requestedBooks,
        "aboutRequester": request.aboutRequester,
        "addressStreet": request.addressStreet,
        "addressCity": request.addressCity,
        "addressState": request.addressState,
        "addressCountry": request.addressCountry,
        "source": request.source,
      ])
    )
  }

  func testQueryFreeOrderWithStreet2() async throws {
    let request: FreeOrderRequest = .mock
    request.addressStreet2 = "hey ho howdy"
    try await Current.db.create(request)

    assertResponse(
      to: /* gql */ """
      query {
        request: getFreeOrderRequest(id: "\(request.id.uuidString)") {
          addressStreet2
        }
      }
      """,
      .containsKeyValuePairs(["addressStreet2": "hey ho howdy"])
    )
  }

  func testCreateFreeOrderRequest() throws {
    let request: Map = .dictionary([
      "email": "foo@bar.com",
      "requestedBooks": "La Senda Antigua",
      "aboutRequester": "not a freebie hunter",
      "name": "Bob",
      "addressStreet": "123 Magnolia Lane",
      "addressStreet2": "apt 2",
      "addressCity": "Beverly Hills",
      "addressState": "CA",
      "addressZip": "90210",
      "addressCountry": "US",
      "source": "https://zoecostarica.com",
    ])

    assertResponse(
      to: /* gql */ """
      mutation CreateFreeOrderRequest($input: CreateFreeOrderRequestInput!) {
        request: createFreeOrderRequest(input: $input) {
          email
          requestedBooks
          aboutRequester
          name
          addressStreet
          addressStreet2
          addressCity
          addressState
          addressZip
          addressCountry
          source
        }
      }
      """,
      withVariables: ["input": request],
      .containsKeyValuePairs([
        "email": "foo@bar.com",
        "requestedBooks": "La Senda Antigua",
        "aboutRequester": "not a freebie hunter",
        "name": "Bob",
        "addressStreet": "123 Magnolia Lane",
        "addressStreet2": "apt 2",
        "addressCity": "Beverly Hills",
        "addressState": "CA",
        "addressZip": "90210",
        "addressCountry": "US",
        "source": "https:\\/\\/zoecostarica.com",
      ])
    )
  }
}
