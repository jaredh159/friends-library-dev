// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension Download {
  enum GraphQL {
    enum Schema {
      enum Inputs {}
      enum Queries {}
      enum Mutations {}
    }
    enum Request {
      enum Inputs {}
      enum Args {}
    }
  }
}

extension Download.GraphQL.Schema {
  static var type: AppType<Download> {
    Type(Download.self) {
      Field("id", at: \.id.rawValue)
      Field("documentId", at: \.documentId.rawValue)
      Field("editionType", at: \.editionType)
      Field("format", at: \.format)
      Field("source", at: \.source)
      Field("audioQuality", at: \.audioQuality)
      Field("audioPartNumber", at: \.audioPartNumber)
      Field("isMobile", at: \.isMobile)
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
      Field("createdAt", at: \.createdAt)
    }
  }
}

extension Download.GraphQL.Request.Inputs {
  struct Create: Codable {
    let id: UUID?
    let documentId: UUID
    let editionType: EditionType
    let format: Download.Format
    let source: Download.DownloadSource
    let audioQuality: Download.AudioQuality?
    let audioPartNumber: Int?
    let isMobile: Bool
    let userAgent: String?
    let os: String?
    let browser: String?
    let platform: String?
    let referrer: String?
    let ip: String?
    let city: String?
    let region: String?
    let postalCode: String?
    let country: String?
    let latitude: String?
    let longitude: String?
  }

  struct Update: Codable {
    let id: UUID
    let documentId: UUID
    let editionType: EditionType
    let format: Download.Format
    let source: Download.DownloadSource
    let audioQuality: Download.AudioQuality?
    let audioPartNumber: Int?
    let isMobile: Bool
    let userAgent: String?
    let os: String?
    let browser: String?
    let platform: String?
    let referrer: String?
    let ip: String?
    let city: String?
    let region: String?
    let postalCode: String?
    let country: String?
    let latitude: String?
    let longitude: String?
  }
}

extension Download.GraphQL.Request.Args {
  struct Create: Codable {
    let input: Download.GraphQL.Request.Inputs.Create
  }

  struct Update: Codable {
    let input: Download.GraphQL.Request.Inputs.Update
  }

  struct UpdateMany: Codable {
    let input: [Download.GraphQL.Request.Inputs.Update]
  }

  struct CreateMany: Codable {
    let input: [Download.GraphQL.Request.Inputs.Create]
  }
}

extension Download.GraphQL.Schema.Inputs {
  static var create: AppInput<Download.GraphQL.Request.Inputs.Create> {
    Input(Download.GraphQL.Request.Inputs.Create.self) {
      InputField("id", at: \.id)
      InputField("documentId", at: \.documentId)
      InputField("editionType", at: \.editionType)
      InputField("format", at: \.format)
      InputField("source", at: \.source)
      InputField("audioQuality", at: \.audioQuality)
      InputField("audioPartNumber", at: \.audioPartNumber)
      InputField("isMobile", at: \.isMobile)
      InputField("userAgent", at: \.userAgent)
      InputField("os", at: \.os)
      InputField("browser", at: \.browser)
      InputField("platform", at: \.platform)
      InputField("referrer", at: \.referrer)
      InputField("ip", at: \.ip)
      InputField("city", at: \.city)
      InputField("region", at: \.region)
      InputField("postalCode", at: \.postalCode)
      InputField("country", at: \.country)
      InputField("latitude", at: \.latitude)
      InputField("longitude", at: \.longitude)
    }
  }

  static var update: AppInput<Download.GraphQL.Request.Inputs.Update> {
    Input(Download.GraphQL.Request.Inputs.Update.self) {
      InputField("id", at: \.id)
      InputField("documentId", at: \.documentId)
      InputField("editionType", at: \.editionType)
      InputField("format", at: \.format)
      InputField("source", at: \.source)
      InputField("audioQuality", at: \.audioQuality)
      InputField("audioPartNumber", at: \.audioPartNumber)
      InputField("isMobile", at: \.isMobile)
      InputField("userAgent", at: \.userAgent)
      InputField("os", at: \.os)
      InputField("browser", at: \.browser)
      InputField("platform", at: \.platform)
      InputField("referrer", at: \.referrer)
      InputField("ip", at: \.ip)
      InputField("city", at: \.city)
      InputField("region", at: \.region)
      InputField("postalCode", at: \.postalCode)
      InputField("country", at: \.country)
      InputField("latitude", at: \.latitude)
      InputField("longitude", at: \.longitude)
    }
  }
}

extension Download.GraphQL.Schema.Queries {
  static var get: AppField<Download, IdentifyEntityArgs> {
    Field("getDownload", at: Resolver.getDownload) {
      Argument("id", at: \.id)
    }
  }

  static var list: AppField<[Download], NoArgs> {
    Field("getDownloads", at: Resolver.getDownloads)
  }
}

extension Download.GraphQL.Schema.Mutations {
  static var create: AppField<Download, Download.GraphQL.Request.Args.Create> {
    Field("createDownload", at: Resolver.createDownload) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[Download], Download.GraphQL.Request.Args.CreateMany> {
    Field("createDownload", at: Resolver.createDownloads) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<Download, Download.GraphQL.Request.Args.Update> {
    Field("createDownload", at: Resolver.updateDownload) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[Download], Download.GraphQL.Request.Args.UpdateMany> {
    Field("createDownload", at: Resolver.updateDownloads) {
      Argument("input", at: \.input)
    }
  }

  static var delete: AppField<Download, IdentifyEntityArgs> {
    Field("deleteDownload", at: Resolver.deleteDownload) {
      Argument("id", at: \.id)
    }
  }
}

extension Download {
  convenience init(_ input: Download.GraphQL.Request.Inputs.Create) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      documentId: .init(rawValue: input.documentId),
      editionType: input.editionType,
      format: input.format,
      source: input.source,
      isMobile: input.isMobile,
      audioQuality: input.audioQuality,
      audioPartNumber: input.audioPartNumber,
      userAgent: input.userAgent,
      os: input.os,
      browser: input.browser,
      platform: input.platform,
      referrer: input.referrer,
      ip: input.ip,
      city: input.city,
      region: input.region,
      postalCode: input.postalCode,
      country: input.country,
      latitude: input.latitude,
      longitude: input.longitude
    )
  }

  func update(_ input: Download.GraphQL.Request.Inputs.Update) throws {
    self.documentId = .init(rawValue: input.documentId)
    self.editionType = input.editionType
    self.format = input.format
    self.source = input.source
    self.audioQuality = input.audioQuality
    self.audioPartNumber = input.audioPartNumber
    self.isMobile = input.isMobile
    self.userAgent = input.userAgent
    self.os = input.os
    self.browser = input.browser
    self.platform = input.platform
    self.referrer = input.referrer
    self.ip = input.ip
    self.city = input.city
    self.region = input.region
    self.postalCode = input.postalCode
    self.country = input.country
    self.latitude = input.latitude
    self.longitude = input.longitude
  }
}
