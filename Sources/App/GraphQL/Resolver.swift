import Fluent
import Foundation
import Graphiti
import Vapor

struct ModelsCounts: Codable {
  let downloads: Int
  let orders: Int
  let orderItems: Int
}

final class Resolver {
  struct IdentifyEntityArgs: Codable {
    let id: UUID
  }

  // this func is used by an automated hourly "up" checker, ensuring that the
  // whole API (including the db) is up and running correctly
  func getModelsCounts(request: Request, args: NoArguments) throws -> Future<ModelsCounts> {
    try request.requirePermission(to: .queryOrders)
    try request.requirePermission(to: .queryDownloads)
    return request.eventLoop.makeSucceededFuture(
      ModelsCounts(downloads: 0, orders: 0, orderItems: 0))
    // @TODO
    // let downloads = Download.query(on: request.db).count()
    // let orders = Order.query(on: request.db).count()
    // let orderItems = OrderItem.query(on: request.db).count()
    // return downloads.and(orders).and(orderItems).map { counts in
    //   let ((downloads, orders), orderItems) = counts
    //   return ModelsCounts(downloads: downloads, orders: orders, orderItems: orderItems)
    // }
  }
}

func future<M>(
  of: M.Type,
  on eventLoop: EventLoop,
  f: @Sendable @escaping () async throws -> M
) -> Future<M> {
  let promise = eventLoop.makePromise(of: M.self)
  promise.completeWithTask(f)
  return promise.futureResult
}
