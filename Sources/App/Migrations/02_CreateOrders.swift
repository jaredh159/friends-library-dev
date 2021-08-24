import Fluent

struct CreateOrders: Migration {
  func prepare(on database: Database) -> Future<Void> {
    let printJobStatusFuture = database.enum("order_print_job_status")
      .case("presubmit")
      .case("pending")
      .case("accepted")
      .case("rejected")
      .case("shipped")
      .case("canceled")
      .case("bricked")
      .create()

    let shippingLevelFuture = database.enum("order_shipping_level")
      .case("mail")
      .case("priorityMail")
      .case("groundHd")
      .case("ground")
      .case("expedited")
      .case("express")
      .create()

    let langFuture = database.enum("lang")
      .case("en")
      .case("es")
      .create()

    let sourceFuture = database.enum("order_source")
      .case("website")
      .case("internal")
      .create()

    return
      printJobStatusFuture
      .and(shippingLevelFuture)
      .and(langFuture)
      .and(sourceFuture)
      .flatMap { types in
        let (((printJobStatus, shippingLevel), lang), source) = types
        return database.schema("orders")
          .id()
          .field("payment_id", .string, .required)
          .field("print_job_status", printJobStatus, .required)
          .field("print_job_id", .int)
          .field("amount", .int, .required)
          .field("shipping", .int, .required)
          .field("taxes", .int, .required)
          .field("cc_fee_offset", .int, .required)
          .field("shipping_level", shippingLevel, .required)
          .field("email", .string, .required)
          .field("address_name", .string, .required)
          .field("address_street", .string, .required)
          .field("address_street2", .string)
          .field("address_city", .string, .required)
          .field("address_state", .string, .required)
          .field("address_zip", .string, .required)
          .field("address_country", .string, .required)
          .field("lang", lang, .required)
          .field("source", source, .required)
          .field("created_at", .datetime, .required)
          .field("updated_at", .datetime, .required)
          .create()
      }
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema("orders").delete()
  }
}
