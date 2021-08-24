import Fluent

struct CreateDownloads: Migration {
  func prepare(on database: Database) -> Future<Void> {
    let editionTypeFuture = database.enum("edition_type")
      .case("updated")
      .case("original")
      .case("modernized")
      .create()

    let audioQualityFuture = database.enum("audio_quality")
      .case("lq")
      .case("hq")
      .create()

    let formatFuture = database.enum("download_format")
      .case("epub")
      .case("mobi")
      .case("webPdf")
      .case("mp3Zip")
      .case("m4b")
      .case("mp3")
      .case("speech")
      .case("podcast")
      .case("appEbook")
      .create()

    let sourceFuture = database.enum("download_source")
      .case("web")
      .case("podcast")
      .case("app")
      .create()

    return
      editionTypeFuture
      .and(audioQualityFuture)
      .and(formatFuture)
      .and(sourceFuture)
      .flatMap { types in
        let (((editionType, audioQuality), format), source) = types
        return database.schema("downloads")
          .id()
          .field("document_id", .uuid, .required)
          .field("edition_type", editionType, .required)
          .field("format", format, .required)
          .field("source", source, .required)
          .field("is_mobile", .bool, .required)
          .field("audio_quality", audioQuality)
          .field("audio_part_number", .int)
          .field("user_agent", .string)
          .field("os", .string)
          .field("browser", .string)
          .field("platform", .string)
          .field("referrer", .string)
          .field("ip", .string)
          .field("city", .string)
          .field("region", .string)
          .field("postalCode", .string)
          .field("country", .string)
          .field("latitude", .string)
          .field("longitude", .string)
          .field("created_at", .datetime, .required)
          .create()
      }
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema("downloads").delete()
  }
}
