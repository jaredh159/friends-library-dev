import PairQL

struct LatestArtifactProductionVersion: Pair {
  static var auth: Scope = .queryArtifactProductionVersions

  struct Output: PairOutput {
    var version: GitCommitSha
  }
}

extension LatestArtifactProductionVersion: NoInputResolver {
  static func resolve(in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)
    let latest = try await ArtifactProductionVersion.query()
      .orderBy(.createdAt, .desc)
      .first()
    return .init(version: latest.version)
  }
}
