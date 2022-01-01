// auto-generated, do not edit
import GraphQL

@testable import App

extension Download {
  static var mock: Download {
    Download(editionId: .init(), format: .epub, source: .website, isMobile: true)
  }

  static var empty: Download {
    Download(editionId: .init(), format: .epub, source: .website, isMobile: false)
  }

  static var random: Download {
    Download(
      editionId: .init(),
      format: Format.allCases.shuffled().first!,
      source: DownloadSource.allCases.shuffled().first!,
      isMobile: Bool.random()
    )
  }

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "id": .string(id.rawValue.uuidString),
      "editionId": .string(editionId.rawValue.uuidString),
      "format": .string(format.rawValue),
      "source": .string(source.rawValue),
      "audioQuality": audioQuality != nil ? .string(audioQuality!.rawValue) : .null,
      "audioPartNumber": audioPartNumber != nil ? .number(Number(audioPartNumber!)) : .null,
      "isMobile": .bool(isMobile),
      "userAgent": userAgent != nil ? .string(userAgent!) : .null,
      "os": os != nil ? .string(os!) : .null,
      "browser": browser != nil ? .string(browser!) : .null,
      "platform": platform != nil ? .string(platform!) : .null,
      "referrer": referrer != nil ? .string(referrer!) : .null,
      "ip": ip != nil ? .string(ip!) : .null,
      "city": city != nil ? .string(city!) : .null,
      "region": region != nil ? .string(region!) : .null,
      "postalCode": postalCode != nil ? .string(postalCode!) : .null,
      "country": country != nil ? .string(country!) : .null,
      "latitude": latitude != nil ? .string(latitude!) : .null,
      "longitude": longitude != nil ? .string(longitude!) : .null,
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
