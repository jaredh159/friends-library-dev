import NonEmpty
import TaggedMoney
import XCTest

@testable import App

final class LuluTests: XCTestCase {

  func testPrices() throws {
    let cases: [(PrintSizeVariant, NonEmpty<[Int]>, Cents<Int>)] = [
      (.s, .init(10), 220),
      (.s, .init(100), 325),
      (.m, .init(100), 325),
      (.m, .init(100, 100), 650),
      (.m, .init(200), 525),
      (.xl, .init(400), 925),
    ]

    for (size, pages, expected) in cases {
      XCTAssertEqual(paperbackPrice(size: size, volumes: pages), expected)
    }
  }
}
