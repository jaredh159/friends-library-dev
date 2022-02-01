import Fluent
import Vapor

struct AddTokenScopes: AsyncMigration {

  func prepare(on database: Database) async throws {
    try await addDbEnumCases(db: database, enumName: TokenScope.M5.dbEnumName, newCases: [
      TokenScope.M24.Scope.caseAll,
      TokenScope.M24.Scope.caseQueryArtifactProductionVersions,
      TokenScope.M24.Scope.caseQueryCoverProps,
      TokenScope.M24.Scope.caseMutateCoverProps,
      TokenScope.M24.Scope.caseQueryEntities,
      TokenScope.M24.Scope.caseMutateEntities,
    ])
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
