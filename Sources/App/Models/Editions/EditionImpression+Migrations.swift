import Fluent

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
