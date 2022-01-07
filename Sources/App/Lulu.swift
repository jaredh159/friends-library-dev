import NonEmpty
import TaggedMoney

// @TODO check if we're not still grandfathered in at old price of 1.4
private let PRICE_PER_PAGE: Double = 2.0

func paperbackPrice(size: PrintSizeVariant, volumes: NonEmpty<[Int]>) -> Cents<Int> {
  volumes.reduce(Cents<Int>(rawValue: 0)) { acc, pages in
    let isSaddleStitch = size == .s && pages < 32
    let basePrice: Cents<Int> = isSaddleStitch ? 200 : 125
    let pagesPrice = (Double(pages) * 2.0).rounded(.toNearestOrAwayFromZero)
    return acc + basePrice + Cents<Int>(rawValue: Int(pagesPrice))
  }
}
