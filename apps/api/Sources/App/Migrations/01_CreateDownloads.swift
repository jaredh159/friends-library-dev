import Fluent
import NonEmpty

struct CreateDownloads: Migration {
  private typealias M1 = Download.M1

  func prepare(on database: Database) -> Future<Void> {
    Current.logger.info("Running migration: CreateDownloads UP")
    let editionTypeFuture = database.enum(M1.EditionTypeEnum.name)
      .case(M1.EditionTypeEnum.caseUpdated)
      .case(M1.EditionTypeEnum.caseModernized)
      .case(M1.EditionTypeEnum.caseOriginal)
      .create()

    let audioQualityFuture = database.enum(M1.AudioQualityEnum.name)
      .case(M1.AudioQualityEnum.caseLq)
      .case(M1.AudioQualityEnum.caseHq)
      .create()

    let formatFuture = database.enum(M1.FormatEnum.name)
      .case(M1.FormatEnum.caseEpub)
      .case(M1.FormatEnum.caseMobi)
      .case(M1.FormatEnum.caseWebPdf)
      .case(M1.FormatEnum.caseMp3Zip)
      .case(M1.FormatEnum.caseM4b)
      .case(M1.FormatEnum.caseMp3)
      .case(M1.FormatEnum.caseSpeech)
      .case(M1.FormatEnum.casePodcast)
      .case(M1.FormatEnum.caseAppEbook)
      .create()

    let sourceFuture = database.enum(M1.SourceEnum.name)
      .case(M1.SourceEnum.caseWebsite)
      .case(M1.SourceEnum.casePodcast)
      .case(M1.SourceEnum.caseApp)
      .create()

    return
      editionTypeFuture
        .and(audioQualityFuture)
        .and(formatFuture)
        .and(sourceFuture)
        .flatMap { types in
          let (((editionType, audioQuality), format), source) = types
          return database.schema(M1.tableName)
            .id()
            .field(M1.documentId, .uuid, .required)
            .field(M1.editionType, editionType, .required)
            .field(M1.format, format, .required)
            .field(M1.source, source, .required)
            .field(M1.isMobile, .bool, .required)
            .field(M1.audioQuality, audioQuality)
            .field(M1.audioPartNumber, .int)
            .field(M1.userAgent, .string)
            .field(M1.os, .string)
            .field(M1.browser, .string)
            .field(M1.platform, .string)
            .field(M1.referrer, .string)
            .field(M1.ip, .string)
            .field(M1.city, .string)
            .field(M1.region, .string)
            .field(M1.postalCode, .string)
            .field(M1.country, .string)
            .field(M1.latitude, .string)
            .field(M1.longitude, .string)
            .field(.createdAt, .datetime, .required)
            .create()
        }
  }

  func revert(on database: Database) -> Future<Void> {
    Current.logger.info("Running migration: CreateDownloads DOWN")
    return database.schema(M1.tableName).delete()
  }
}
