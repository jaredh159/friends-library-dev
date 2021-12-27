import Fluent
import Foundation
import NonEmpty
import Tagged

final class EditionImpression: Codable {
  var id: Id
  var editionId: Edition.Id
  var adocLength: Int
  var paperbackSize: PrintSizeVariant
  var paperbackVolumes: NonEmpty<[Int]>
  var publishedRevision: GitCommitSha
  var productionToolchainRevision: GitCommitSha
  var createdAt = Current.date()

  var edition = Parent<Edition>.notLoaded

  init(
    id: Id = .init(),
    editionId: Edition.Id,
    adocLength: Int,
    paperbackSize: PrintSizeVariant,
    paperbackVolumes: NonEmpty<[Int]>,
    publishedRevision: GitCommitSha,
    productionToolchainRevision: GitCommitSha
  ) {
    self.id = id
    self.editionId = editionId
    self.adocLength = adocLength
    self.paperbackSize = paperbackSize
    self.paperbackVolumes = paperbackVolumes
    self.publishedRevision = publishedRevision
    self.productionToolchainRevision = productionToolchainRevision
  }
}

// extensions

extension EditionImpression {
  enum M17 {
    static let tableName = "edition_impressions"
    static let editionId = FieldKey("edition_id")
    static let adocLength = FieldKey("adoc_length")
    static let publishedRevision = FieldKey("published_revision")
    static let productionToolchainRevision = FieldKey("production_toolchain_revision")
    static let paperbackSize = FieldKey("paperback_size")
    static let paperbackVolumes = FieldKey("paperback_volumes")
  }
}
