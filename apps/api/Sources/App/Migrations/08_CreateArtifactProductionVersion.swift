import Fluent
import Vapor

struct CreateArtifactProductionVersion: Migration {

  func prepare(on database: Database) -> Future<Void> {
    Current.logger.info("Running migration: CreateArtifactProductionVersion UP")
    return database.schema(ArtifactProductionVersion.M8.tableName)
      .id()
      .field(ArtifactProductionVersion.M8.version, .string, .required)
      .field(.createdAt, .datetime, .required)
      .unique(on: ArtifactProductionVersion.M8.version)
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    Current.logger.info("Running migration: CreateArtifactProductionVersion DOWN")
    return database.schema(FreeOrderRequest.M6.tableName).delete()
  }
}
