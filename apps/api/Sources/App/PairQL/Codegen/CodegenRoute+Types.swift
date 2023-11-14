import PairQL
import TypeScriptInterop
import Vapor

protocol CodegenRouteHandler: RouteHandler {
  static var sharedTypes: [(String, Any.Type)] { get }
  static var pairqlPairs: [any Pair.Type] { get }
}

extension CodegenRouteHandler {
  static func handler(_ request: Request) async throws -> Response {
    var shared: [String: String] = [:]
    var sharedAliases: [Config.Alias] = [
      .init(NoInput.self, as: "void"),
      .init(Date.self, as: "ISODateString"),
    ]
    var config = Config(compact: true, aliasing: sharedAliases)

    for (name, type) in sharedTypes {
      shared[name] = try CodeGen(config: config).declaration(for: type, as: name)
      sharedAliases.append(.init(type, as: name))
      config = .init(compact: true, aliasing: sharedAliases)
    }

    var pairs: [String: CodegenRoute.Output.Pair] = [:]
    for pairType in pairqlPairs {
      pairs[pairType.name] = try .init(for: pairType, with: config)
    }

    return Response(CodegenRoute.Output(shared: shared, pairs: pairs))
  }
}
