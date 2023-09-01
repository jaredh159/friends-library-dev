import Foundation
import Tagged
import TypeScriptInterop

extension Tagged: TypeScriptAliased where RawValue == UUID {
  public static var typescriptAlias: String {
    "UUID"
  }
}
