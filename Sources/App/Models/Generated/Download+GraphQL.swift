// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var DownloadType: AppType<Download> {
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

  struct CreateDownloadInput: Codable {
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

  struct UpdateDownloadInput: Codable {
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

  struct CreateDownloadArgs: Codable {
    let input: AppSchema.CreateDownloadInput
  }

  struct UpdateDownloadArgs: Codable {
    let input: AppSchema.UpdateDownloadInput
  }

  struct CreateDownloadsArgs: Codable {
    let input: [AppSchema.CreateDownloadInput]
  }

  struct UpdateDownloadsArgs: Codable {
    let input: [AppSchema.UpdateDownloadInput]
  }

  static var CreateDownloadInputType: AppInput<AppSchema.CreateDownloadInput> {
    Input(AppSchema.CreateDownloadInput.self) {
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

  static var UpdateDownloadInputType: AppInput<AppSchema.UpdateDownloadInput> {
    Input(AppSchema.UpdateDownloadInput.self) {
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

  static var getDownload: AppField<Download, IdentifyEntityArgs> {
    Field("getDownload", at: Resolver.getDownload) {
      Argument("id", at: \.id)
    }
  }

  static var getDownloads: AppField<[Download], NoArgs> {
    Field("getDownloads", at: Resolver.getDownloads)
  }

  static var createDownload: AppField<Download, AppSchema.CreateDownloadArgs> {
    Field("createDownload", at: Resolver.createDownload) {
      Argument("input", at: \.input)
    }
  }

  static var createDownloads: AppField<[Download], AppSchema.CreateDownloadsArgs> {
    Field("createDownloads", at: Resolver.createDownloads) {
      Argument("input", at: \.input)
    }
  }

  static var updateDownload: AppField<Download, AppSchema.UpdateDownloadArgs> {
    Field("updateDownload", at: Resolver.updateDownload) {
      Argument("input", at: \.input)
    }
  }

  static var updateDownloads: AppField<[Download], AppSchema.UpdateDownloadsArgs> {
    Field("updateDownloads", at: Resolver.updateDownloads) {
      Argument("input", at: \.input)
    }
  }

  static var deleteDownload: AppField<Download, IdentifyEntityArgs> {
    Field("deleteDownload", at: Resolver.deleteDownload) {
      Argument("id", at: \.id)
    }
  }
}

extension Download {
  convenience init(_ input: AppSchema.CreateDownloadInput) {
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

  func update(_ input: AppSchema.UpdateDownloadInput) {
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
