import Foundation

struct Environment {
  var uuid = { UUID() }
  var db: Db!
}

var Current = Environment()

extension UUID {
  static let mock = UUID("3EFC3511-999E-4385-A071-E5B0965C4AFD")!
}
