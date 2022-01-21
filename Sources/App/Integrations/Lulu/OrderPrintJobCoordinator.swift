import Foundation

enum OrderPrintJobCoordinator {

  // aside... slack logging should current.log as well

  static func createNewPrintJobs() async throws {
    // fetch all orders in .presubmit status
    // no orders? bail
    // for each order...
    // create a print job, logging creation and errors
    // update order status (pending), and printJobId, then save
  }

  static func checkPendingOrders() async throws {
    // fetch all orders in `.pending` status
    // fetch print jobs from lulu
    // any in ERROR, CANCELED, REJECTED state?
    // -> slack the error, update the order to `rejected`
    // -> otherwise slack log the acceptance & update order to .accepted
  }

  static func sendTrackingEmails() async throws {
    // query orders with status .accepted
    // query lulu for print job orders corresponsing to those orders
    // for each print job...
    // -> unpaid?  slack an error
    // -> rejected | canceled? slack an error, and update the order
    // -> shipped? send an email, update the order
  }
}
