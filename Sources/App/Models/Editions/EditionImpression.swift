import Fluent
import Foundation
import NonEmpty
import Tagged

final class EditionImpression {
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

extension EditionImpression: AppModel {
  typealias Id = Tagged<EditionImpression, UUID>
}

extension EditionImpression: DuetModel {
  static let tableName = M17.tableName
}

extension EditionImpression: Codable {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case editionId
    case adocLength
    case paperbackSize
    case paperbackVolumes
    case publishedRevision
    case productionToolchainRevision
    case createdAt
  }
}

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
