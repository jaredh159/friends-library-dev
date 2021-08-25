import Fluent
import Foundation
import Graphiti
import Vapor

let AppSchema = try! Graphiti.Schema<Resolver, Request> {
  Scalar(UUID.self)
  DateScalar(formatter: ISO8601DateFormatter())
  Enum(EditionType.self)
  Enum(Download.Format.self)
  Enum(Download.AudioQuality.self)
  Enum(Download.Source.self)

  Type(Download.self) {
    Field("id", at: \.id)
    Field("documentId", at: \.documentId)
    Field("editionType", at: \.editionType)
    Field("format", at: \.format)
    Field("source", at: \.source)
    Field("isMobile", at: \.isMobile)
    Field("audioQuality", at: \.audioQuality)
    Field("audioPartNumber", at: \.audioPartNumber)
    Field("userAgent", at: \.userAgent)
    Field("os", at: \.os)
    Field("browser", at: \.browser)
    Field("platform", at: \.platform)
    Field("referrer", at: \.referrer)
    Field("ip", at: \.ip)
    Field("city", at: \.city)
    Field("region", at: \.region)
    Field("postalCode", at: \.postalCode)
    Field("country", at: \.country)
    Field("latitude", at: \.latitude)
    Field("longitude", at: \.longitude)
  }

  Query {
    Field("getLol", at: Resolver.getLol)
  }

  Mutation {
    Field("createDownload", at: Resolver.createDownload) {
      Argument("documentId", at: \.documentId)
      Argument("editionType", at: \.editionType)
      Argument("format", at: \.format)
      Argument("source", at: \.source)
      Argument("isMobile", at: \.isMobile)
      Argument("audioQuality", at: \.audioQuality)
      Argument("audioPartNumber", at: \.audioPartNumber)
      Argument("userAgent", at: \.userAgent)
      Argument("os", at: \.os)
      Argument("browser", at: \.browser)
      Argument("platform", at: \.platform)
      Argument("referrer", at: \.referrer)
      Argument("ip", at: \.ip)
      Argument("city", at: \.city)
      Argument("region", at: \.region)
      Argument("postalCode", at: \.postalCode)
      Argument("country", at: \.country)
      Argument("latitude", at: \.latitude)
      Argument("longitude", at: \.longitude)
    }
  }
}
