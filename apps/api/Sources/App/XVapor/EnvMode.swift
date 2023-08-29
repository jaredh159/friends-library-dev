import Vapor

extension Vapor.Environment {
  static var mode = Mode.dev

  enum Mode: Equatable {
    case prod
    case dev
    case staging
    case test

    init(from env: Env) {
      switch env.name {
      case "production":
        self = .prod
      case "development":
        self = .dev
      case "staging":
        self = .staging
      case "testing":
        self = .test
      default:
        fatalError("Unexpected environment: \(env.name)")
      }
    }

    var name: String {
      switch self {
      case .prod:
        return "production"
      case .dev:
        return "development"
      case .staging:
        return "staging"
      case .test:
        return "testing"
      }
    }

    var coloredName: String {
      switch self {
      case .prod:
        return name.uppercased().red.bold
      case .dev:
        return name.uppercased().green.bold
      case .staging:
        return name.uppercased().yellow.bold
      case .test:
        return name.uppercased().magenta.bold
      }
    }
  }
}
