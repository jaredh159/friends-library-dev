import Fluent
import Vapor

struct AddTokenScopes: AsyncMigration {

  func prepare(on database: Database) async throws {
    _ = try await database.enum(TokenScope.M5.dbEnumName)
      .case(TokenScope.M23.Scope.caseMutateFriends)
      .case(TokenScope.M23.Scope.caseQueryFriends)
      .case(TokenScope.M23.Scope.caseMutateDocuments)
      .case(TokenScope.M23.Scope.caseQueryDocuments)
      .case(TokenScope.M23.Scope.caseMutateEditionImpressions)
      .case(TokenScope.M23.Scope.caseQueryEditionImpressions)
      .case(TokenScope.M23.Scope.caseMutateAudios)
      .case(TokenScope.M23.Scope.caseQueryAudios)
      .case(TokenScope.M23.Scope.caseQueryArtifactProductionVersions)
      .case(TokenScope.M23.Scope.caseMutateIsbns)
      .case(TokenScope.M23.Scope.caseQueryIsbns)
      .case(TokenScope.M23.Scope.caseMutateEditionChapters)
      .case(TokenScope.M23.Scope.caseQueryEditionChapters)
      .case(TokenScope.M23.Scope.caseQueryCoverProps)
      .update()
  }

  func revert(on database: Database) async throws {
    // I don't think postgres supports deleting enum cases... ¯\_(ツ)_/¯
  }
}

extension TokenScope {
  enum M23 {
    enum Scope {
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
      static let caseMutateEditionChapters = "mutateEditionChapters"
      static let caseQueryEditionChapters = "queryEditionChapters"
      static let caseQueryCoverProps = "queryCoverProps"
    }
  }
}
