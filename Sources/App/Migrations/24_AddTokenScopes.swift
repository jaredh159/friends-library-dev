import Fluent
import Vapor

struct AddTokenScopes: AsyncMigration {

  func prepare(on database: Database) async throws {
    _ = try await database.enum(TokenScope.M5.dbEnumName)
      .case(TokenScope.M24.Scope.caseAll)
      .case(TokenScope.M24.Scope.caseQueryArtifactProductionVersions)
      .case(TokenScope.M24.Scope.caseQueryCoverProps)
      .case(TokenScope.M24.Scope.caseMutateCoverProps)
      .case(TokenScope.M24.Scope.caseQueryEntities)
      .case(TokenScope.M24.Scope.caseMutateEntities)
      .update()
  }

  func revert(on database: Database) async throws {
    // I don't think postgres supports deleting enum cases... ¯\_(ツ)_/¯
  }
}

extension TokenScope {
  enum M24 {
    enum Scope {
      static let caseAll = "all"
      static let caseQueryArtifactProductionVersions = "queryArtifactProductionVersions"
      static let caseQueryCoverProps = "queryCoverProps"
      static let caseMutateCoverProps = "mutateCoverProps"
      static let caseQueryEntities = "queryEntities"
      static let caseMutateEntities = "mutateEntities"
    }
  }
}
