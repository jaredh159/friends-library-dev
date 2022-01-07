import Foundation
import NonEmpty
import TaggedMoney

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

  var paperbackPrice: Cents<Int> {
    Lulu.paperbackPrice(size: paperbackSize, volumes: paperbackVolumes)
  }

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
