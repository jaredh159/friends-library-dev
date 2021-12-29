extension ArtifactProductionVersion {
  static let mock: ArtifactProductionVersion {
    ArtifactProductionVersion(version: .init(rawValue: "@mock version"))
  }

  static let empty: ArtifactProductionVersion {
    ArtifactProductionVersion(version: .init(rawValue: ""))
  }
}
