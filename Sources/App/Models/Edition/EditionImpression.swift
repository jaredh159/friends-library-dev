import Fluent
import Foundation
import NonEmpty
import Vapor

final class EditionImpression: Model, Content {
  static let schema = M17.tableName

  @ID(key: .id)
  var id: UUID?

  // @Parent(key: M17.editionId)
  // var edition: Edition

  @Field(key: M17.adocLength)
  var adocLength: Int

  @Enum(key: M17.paperbackSize)
  var paperbackSize: PrintSizeVariant

  @Field(key: M17.paperbackVolumes)
  var paperbackVolumes: NonEmpty<[Int]>

  @Field(key: M17.publishedRevision)
  var publishedRevision: GitCommitSha

  @Field(key: M17.productionToolchainRevision)
  var productionToolchainRevision: GitCommitSha

  @Timestamp(key: .createdAt, on: .create)
  var createdAt: Date?
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
