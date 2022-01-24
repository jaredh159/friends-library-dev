import Foundation
import NonEmpty

enum OrderPrintJobCoordinator {
  typealias JobCreator = (Order) async throws -> Lulu.Api.PrintJob

  static func createNewPrintJobs(
    _ createPrintJob: JobCreator = PrintJobService.createPrintJob(_:)
  ) async {
    let orders: [Order]
    do {
      orders = try await Current.db.query(Order.self)
        .where(.printJobStatus == .enum(Order.PrintJobStatus.presubmit))
        .all()
    } catch {
      await slack(.error("Error querying presubmit orders: \(error)"))
      return
    }

    guard !orders.isEmpty else {
      return
    }

    var updated: [Order] = []
    for order in orders {
      do {
        let job = try await createPrintJob(order)
        if job.status.name != .created {
          await slack(
            .error("Unexpected print job status \(job.status.name.rawValue) for order \(order.id)")
          )
        } else {
          order.printJobStatus = .pending
          order.printJobId = .init(rawValue: Int(job.id))
          updated.append(order)
          await slack(.order("Created print job \(job.id) for order \(order.id)"))
        }
      } catch {
        await slack(.error("Error creating print job for order \(order.id): \(error)"))
      }
    }

    if !updated.isEmpty {
      do {
        try await Current.db.update(updated)
      } catch {
        await slack(.error("Error updating orders: \(error)"))
      }
    }
  }

  static func checkPendingOrders() async {
    guard let (orders, printJobs) = await getOrdersWithPrintJobs(status: .pending) else {
      return
    }

    var updated: [Order] = []
    for order in orders {
      guard let printJob = printJobs.first(where: order |> belongsToPrintJob) else {
        await slack(.error("Failed to find print job belonging to order \(order.id)"))
        continue
      }

      let status = printJob.status.name.rawValue
      switch printJob.status.name {
        case .created:
          break
        case .unpaid:
          await slack(.error("Print job \(printJob.id) found in state \(status)"))
        case .rejected,
             .canceled,
             .error:
          order.printJobStatus = .rejected
          updated.append(order)
          await slack(.error("Print job \(printJob.id) for order \(order.id) rejected"))
        case .paymentInProgress,
             .productionReady,
             .productionDelayed,
             .shipped,
             .inProduction:
          order.printJobStatus = .accepted
          updated.append(order)
          await slack(.order("Verified acceptance of print job \(printJob.id), status: \(status)"))
      }
    }

    await updateOrders(updated)
  }

  static func sendTrackingEmails() async {
    guard let (orders, printJobs) = await getOrdersWithPrintJobs(status: .accepted) else {
      return
    }

    var updated: [Order] = []
    for order in orders {
      guard let printJob = printJobs.first(where: order |> belongsToPrintJob) else {
        await slack(.error("Failed to find print job belonging to order \(order.id)"))
        continue
      }

      let status = printJob.status.name.rawValue
      switch printJob.status.name {
        case .unpaid:
          await slack(.error("Print job \(printJob.id) found in state \(status)"))
        case .canceled, .rejected:
          order.printJobStatus = printJob.status.name == .canceled ? .canceled : .rejected
          updated.append(order)
          await slack(.error("order \(order.id) was \(status)!"))
        case .shipped:
          order.printJobStatus = .shipped
          updated.append(order)
          await sendOrderShippedEmail(order, printJob)
          await slack(.order("Order \(order.id.lowercased) shipped"))
        case .paymentInProgress,
             .productionReady,
             .productionDelayed,
             .inProduction,
             .error,
             .created:
          break
      }
    }

    await updateOrders(updated)
  }
}

// helpers

private func sendOrderShippedEmail(_ order: Order, _ printJob: Lulu.Api.PrintJob) async {
  do {
    let trackingUrl = printJob.lineItems.compactMap { $0.trackingUrls?.first }.first
    let email = try await EmailBuilder.orderShipped(order, trackingUrl: trackingUrl)
    try await Current.sendGridClient.send(email)
  } catch {
    await slack(.error("Error sending order shipped email for order \(order.id): \(error)"))
  }
}

private func updateOrders(_ orders: [Order]) async {
  guard !orders.isEmpty else { return }
  do {
    try await Current.db.update(orders)
  } catch {
    let ids = orders.map { $0.id.rawValue.uuidString }.joined(separator: ", ")
    await slack(.error("Error updating orders: [\(ids)]"))
  }
}

private func getOrdersWithPrintJobs(
  status: Order.PrintJobStatus
) async -> (orders: [Order], printJobs: [Lulu.Api.PrintJob])? {
  let orders: [Order]
  let printJobs: [Lulu.Api.PrintJob]
  do {
    orders = try await Current.db.query(Order.self)
      .where(.printJobStatus == .enum(status))
      .all()

    guard let printJobIds = await orderPrintJobIds(orders) else {
      return nil
    }

    printJobs = try await Current.luluClient.listPrintJobs(printJobIds)
  } catch {
    await slack(.error("Error querying orders & print jobs: \(error)"))
    return nil
  }
  return (orders: orders, printJobs: printJobs)
}

private func orderPrintJobIds(_ orders: [Order]) async -> NonEmpty<[Int64]>? {
  guard !orders.isEmpty else {
    return nil
  }

  let ids = try? NonEmpty<[Int64]>.fromArray(
    orders.compactMap { $0.printJobId?.rawValue }.map(Int64.init)
  )

  guard let printJobIds = ids, printJobIds.count == orders.count else {
    let ids = orders.map { "\($0.id)" }.joined(separator: ", ")
    await slack(.error("Unexpected missing print job id in orders: [\(ids)]"))
    return nil
  }

  return printJobIds
}

private func belongsToPrintJob(_ order: Order) -> (Lulu.Api.PrintJob) -> Bool {
  return { printJob in
    printJob.id == Int64(order.printJobId?.rawValue ?? -1)
  }
}

private func slack(_ message: Slack.Message) async {
  try? await Current.slackClient.send(message)
}
