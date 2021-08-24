import Fluent
import FluentPostgresDriver
import GraphQLKit
import QueuesFluentDriver
import Vapor

typealias Future = EventLoopFuture

public func configure(_ app: Application) throws {
  let dbPrefix = app.environment == .testing ? "TEST_" : ""
  app.databases.use(
    .postgres(
      hostname: Environment.get("DATABASE_HOST") ?? "localhost",
      port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:))
        ?? PostgresConfiguration.ianaPortNumber,
      username: Environment.DATABASE_USERNAME,
      password: Environment.DATABASE_PASSWORD,
      database: Environment.get("\(dbPrefix)DATABASE_NAME")!
    ), as: .psql)

  addMigrations(to: app)

  app.register(graphQLSchema: AppSchema, withResolver: Resolver())

  if app.environment == .production {
    try configureScheduledJobs(app)
  }

  if app.environment != .production {
    try app.autoMigrate().wait()
  }

  app.logger.notice("App environment is `\(app.environment.name)`")
}

private func addMigrations(to app: Application) {
  app.migrations.add(CreateDownloads())
  app.migrations.add(CreateOrders())
  app.migrations.add(CreateOrderItems())

  if Environment.get("SEED_DB") == "true" {
    app.migrations.add(Seed())
  }
}

private func configureScheduledJobs(_ app: Application) throws {
  // since we're not using redis, only have one core (currently)
  // and are just doing very low frequency tasks, throttle way down
  // app.queues.configuration.workerCount = 1
  // app.queues.configuration.refreshInterval = .seconds(300)

  // app.queues.use(.fluent(useSoftDeletes: false))
  // app.queues.schedule(BackupJob()).daily().at(4, 00, .am)  // 2am EST
  // app.queues.schedule(CleanupJob()).daily().at(4, 30, .am)  // 2:30am EST
  // try app.queues.startScheduledJobs()
}
