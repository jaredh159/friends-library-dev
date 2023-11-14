import Foundation
import PairQL
import Tagged
import TypeScriptInterop

extension Tagged: TypeScriptAliased {
  public static var typescriptAlias: String {
    switch RawValue.self {
    case is UUID.Type: return "UUID"
    case is String.Type: return "string"
    case is any Numeric.Type: return "number"
    case is Bool.Type: return "boolean"
    default: fatalError("Typescript alias not declared for tagged `\(RawValue.self)`")
    }
  }
}

extension Tagged: PairInput where RawValue: Codable & Equatable {}
extension Tagged: PairOutput where RawValue: Codable & Equatable {}
