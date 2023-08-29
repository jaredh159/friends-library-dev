import PairQL

struct CreateArtifactProductionVersion: Pair {
  static var auth: Scope = .mutateArtifactProductionVersions

  struct Input: PairInput {
    var version: GitCommitSha
  }

  struct Output: PairOutput {
    var id: ArtifactProductionVersion.Id
  }
}

extension CreateArtifactProductionVersion: PairQL.Resolver {
  static func resolve(with input: Input, in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)
    let apf = try await ArtifactProductionVersion.create(.init(version: input.version))
    return Output(id: apf.id)
  }
}
