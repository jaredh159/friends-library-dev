import Foundation

@testable import App

extension ArtifactProductionVersion {
  static var mockOld: ArtifactProductionVersion {
    let model: ArtifactProductionVersion = .mock
    model.createdAt = .init(subtractingDays: 3)
    return model
  }
}
