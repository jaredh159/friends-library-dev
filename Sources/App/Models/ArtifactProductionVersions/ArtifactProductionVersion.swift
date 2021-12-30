import Foundation

final class ArtifactProductionVersion: Codable {
  var id: Id
  var version: GitCommitSha
  var createdAt = Current.date()

  init(id: Id = .init(), version: GitCommitSha) {
    self.id = id
    self.version = version
  }
}
