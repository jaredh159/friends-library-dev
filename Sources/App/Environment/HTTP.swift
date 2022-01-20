import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

enum HTTP {
  enum AuthType {
    case bearer(String)
    case basic(String, String)
    case basicUnencoded(String)
    case basicEncoded(String)
  }

  enum Method: String {
    case post = "POST"
    case get = "GET"
  }

  static func postJson<Body: Encodable>(
    _ body: Body,
    to urlString: String,
    headers: [String: String] = [:],
    auth: AuthType? = nil,
    keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys
  ) async throws -> (Data, URLResponse) {
    var request = try urlRequest(to: urlString, method: .post, headers: headers, auth: auth)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = keyEncodingStrategy
    request.httpBody = try encoder.encode(body)
    return try await URLSession.shared.data(for: request)
  }

  static func postJson<Body: Encodable, Response: Decodable>(
    _ body: Body,
    to urlString: String,
    decoding: Response.Type,
    headers: [String: String] = [:],
    auth: AuthType? = nil,
    keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys,
    keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
  ) async throws -> Response {
    let (data, _) = try await postJson(
      body,
      to: urlString,
      headers: headers,
      auth: auth,
      keyEncodingStrategy: keyEncodingStrategy
    )
    // print("\(String(data: data, encoding: .utf8)!)")
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = keyDecodingStrategy
      return try decoder.decode(Response.self, from: data)
    } catch {
      throw HttpError.decodingError(error, String(data: data, encoding: .utf8) ?? "")
    }
  }

  static func postFormUrlencoded(
    _ params: [String: String],
    to urlString: String,
    headers: [String: String] = [:],
    auth: AuthType? = nil
  ) async throws -> (Data, URLResponse) {
    var request = try urlRequest(to: urlString, method: .post, headers: headers, auth: auth)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    let query = params.map { key, value in "\(key)=\(value)" }.joined(separator: "&")
    request.httpBody = query.data(using: .utf8)
    return try await URLSession.shared.data(for: request)
  }

  static func get<T: Decodable>(
    _ urlString: String,
    decoding: T.Type,
    headers: [String: String] = [:],
    auth: AuthType? = nil,
    keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
  ) async throws -> T {
    let request = try urlRequest(to: urlString, method: .get, headers: headers, auth: auth)
    let (data, _) = try await URLSession.shared.data(for: request)
    // print("\(String(data: data, encoding: .utf8)!)")
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = keyDecodingStrategy
      return try decoder.decode(T.self, from: data)
    } catch {
      throw HttpError.decodingError(error, String(data: data, encoding: .utf8) ?? "")
    }
  }

  static func get(
    _ urlString: String,
    headers: [String: String] = [:],
    auth: AuthType? = nil
  ) async throws -> (Data, URLResponse) {
    let request = try urlRequest(to: urlString, method: .get, headers: headers, auth: auth)
    return try await URLSession.shared.data(for: request)
  }

  static func postFormUrlencoded<T: Decodable>(
    _ params: [String: String],
    to urlString: String,
    decoding: T.Type,
    headers: [String: String] = [:],
    auth: AuthType? = nil,
    keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
  ) async throws -> T {
    let (data, _) = try await postFormUrlencoded(
      params,
      to: urlString,
      headers: headers,
      auth: auth
    )
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = keyDecodingStrategy
    return try decoder.decode(T.self, from: data)
  }

  private static func urlRequest(
    to urlString: String,
    method: Method,
    headers: [String: String] = [:],
    auth: AuthType? = nil
  ) throws -> URLRequest {
    guard let url = URL(string: urlString) else {
      throw HttpError.invalidUrl(urlString)
    }
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    headers.forEach { key, value in request.setValue(value, forHTTPHeaderField: key) }
    switch auth {
      case .bearer(let token):
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
      case .basicEncoded(let string):
        request.setValue("Basic \(string)", forHTTPHeaderField: "Authorization")
      case .basic(let username, let password):
        guard let data = "\(username):\(password)".data(using: .utf8) else {
          throw HttpError.base64EncodingFailed
        }
        let encoded = data.base64EncodedString()
        request.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")
      case .basicUnencoded(let string):
        guard let data = string.data(using: .utf8) else {
          throw HttpError.base64EncodingFailed
        }
        let encoded = data.base64EncodedString()
        request.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")
      case nil:
        break
    }
    return request
  }
}

enum HttpError: Error, LocalizedError {
  case invalidUrl(String)
  case base64EncodingFailed
  case decodingError(Error, String)

  var errorDescription: String? {
    switch self {
      case .invalidUrl(let string):
        return "Invalid URL string: \(string)"
      case .base64EncodingFailed:
        return "base64Endoding failed"
      case .decodingError(let error, let raw):
        return "JSON decoding failed. Error=\(error), Raw=\(raw)"
    }
  }
}
