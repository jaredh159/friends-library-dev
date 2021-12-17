import Foundation

@testable import App

extension ArtifactProductionVersion {
  static var mock: ArtifactProductionVersion {
    ArtifactProductionVersion(version: .init(rawValue: UUID().uuidString))
  }

  static var mockOld: ArtifactProductionVersion {
    let model = ArtifactProductionVersion(version: .init(rawValue: UUID().uuidString))
    model.createdAt = .init(subtractingDays: 3)
    return model
  }
}
