import Fluent
import Vapor

struct AddTokenScopes: AsyncMigration {

  func prepare(on database: Database) async throws {
    _ = try await database.enum(TokenScope.M5.dbEnumName)
      .case(TokenScope.M24.Scope.caseAll)
      .case(TokenScope.M24.Scope.caseMutateFriends)
      .case(TokenScope.M24.Scope.caseQueryFriends)
      .case(TokenScope.M24.Scope.caseMutateDocuments)
      .case(TokenScope.M24.Scope.caseQueryDocuments)
      .case(TokenScope.M24.Scope.caseMutateEditionImpressions)
      .case(TokenScope.M24.Scope.caseQueryEditionImpressions)
      .case(TokenScope.M24.Scope.caseMutateEditions)
      .case(TokenScope.M24.Scope.caseQueryEditions)
      .case(TokenScope.M24.Scope.caseMutateAudios)
      .case(TokenScope.M24.Scope.caseQueryAudios)
      .case(TokenScope.M24.Scope.caseQueryArtifactProductionVersions)
      .case(TokenScope.M24.Scope.caseMutateIsbns)
      .case(TokenScope.M24.Scope.caseQueryIsbns)
      .case(TokenScope.M24.Scope.caseMutateEditionChapters)
      .case(TokenScope.M24.Scope.caseQueryEditionChapters)
      .case(TokenScope.M24.Scope.caseQueryCoverProps)
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
      static let caseMutateFriends = "mutateFriends"
      static let caseQueryFriends = "queryFriends"
      static let caseMutateDocuments = "mutateDocuments"
      static let caseQueryDocuments = "queryDocuments"
      static let caseMutateEditionImpressions = "mutateEditionImpressions"
      static let caseQueryEditionImpressions = "queryEditionImpressions"
      static let caseMutateAudios = "mutateAudios"
      static let caseQueryAudios = "queryAudios"
      static let caseQueryArtifactProductionVersions = "queryArtifactProductionVersions"
      static let caseMutateIsbns = "mutateIsbns"
      static let caseQueryIsbns = "queryIsbns"
      static let caseMutateEditions = "mutateEditions"
      static let caseQueryEditions = "queryEditions"
      static let caseMutateEditionChapters = "mutateEditionChapters"
      static let caseQueryEditionChapters = "queryEditionChapters"
      static let caseQueryCoverProps = "queryCoverProps"
    }
  }
}
