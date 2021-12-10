import Foundation

struct Environment {
  var uuid: () -> UUID = UUID.init
  var date: () -> Date = Date.init
  var db: DatabaseClient = .notImplemented
}

var Current = Environment()

extension UUID {
  static let mock = UUID("3EFC3511-999E-4385-A071-E5B0965C4AFD")!
}

struct LolCodingKey: CodingKey {
  var stringValue: String

  init(stringValue: String) {
    self.stringValue = stringValue
  }

  var intValue: Int? = nil

  init?(intValue: Int) {
    return nil
  }

}
