import Queues
import Vapor

public struct ProcessOrdersJob: ScheduledJob {
  public func run(context: QueueContext) -> EventLoopFuture<Void> {
    future(of: Void.self, on: context.eventLoop) {
      await OrderPrintJobCoordinator.createNewPrintJobs()
      await OrderPrintJobCoordinator.checkPendingOrders()
      await OrderPrintJobCoordinator.sendTrackingEmails()
    }
  }
}
