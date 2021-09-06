import Fluent
import FluentPostgresDriver
import GraphQLKit
import QueuesFluentDriver
import Vapor
import VaporUtils

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

  app
    .grouped(UserAuthenticator())
    .register(graphQLSchema: AppSchema, withResolver: Resolver())

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
  app.migrations.add(CreateTokens())
  app.migrations.add(CreateTokenScopes())

  if Environment.get("SEED_DB") == "true" || app.environment == .testing {
    app.migrations.add(Seed())
  }
}

private func configureScheduledJobs(_ app: Application) throws {
  // since we're not using redis, only have one core (currently)
  // and are just doing very low frequency tasks, throttle way down
  app.queues.configuration.workerCount = 1
  app.queues.configuration.refreshInterval = .seconds(300)

  app.queues.use(.fluent(useSoftDeletes: false))

  let backupJob = BackupJob(
    appName: "FLP",
    dbName: Environment.DATABASE_NAME,
    pgDumpPath: Environment.PG_DUMP_PATH,
    gzipPath: Environment.GZIP_PATH,
    sendGridApiKey: Environment.SENDGRID_API_KEY,
    fromEmail: .init(
      email: "notifications@graphql-api.friendslibrary.com",
      name: "FLP GraphQL"
    )
  )

  app.queues.schedule(backupJob).daily().at(4, 00, .am)  // 2am EST

  try app.queues.startScheduledJobs()
}
