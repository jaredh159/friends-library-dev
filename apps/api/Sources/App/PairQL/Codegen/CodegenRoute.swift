import PairQL
import TypeScriptInterop
import Vapor

enum CodegenRoute: RouteHandler {
  struct Output: Content {
    struct Pair: Content {
      let decl: String
      let fetcher: String
    }

    var shared: [String: String]
    var pairs: [String: Pair]
  }

  static func handler(_ request: Request) async throws -> Response {
    switch request.parameters.get("domain") {
    case "dev":
      return try await CodegenRoute.Dev.handler(request)
    default:
      throw Abort(.notFound, reason: "invalid pairql domain")
    }
  }
}

// domains

extension CodegenRoute {
  enum Dev {}
  enum Evans {}
  enum Admin {}
}

// extensions

extension CodegenRoute.Output.Pair {
  init<P: Pair>(
    for type: P.Type,
    with config: Config
  ) throws {
    let codegen = CodeGen(config: config)
    let name = "\(P.self)"
    var decl = """
    export namespace \(name) {
      \(try codegen.declaration(for: P.Input.self, as: "Input"))

      \(try codegen.declaration(for: P.Output.self, as: "Output"))
    }
    """

    // pairs that are only typealiases get compacted more
    let pairLines = decl.split(separator: "\n")
    if pairLines.count == 4, pairLines.allSatisfy({ $0.count < 60 }) {
      decl = pairLines.joined(separator: "\n")
    }

    var fetchName = "\(name)".regexReplace("_.*$", "")
    let firstLetter = fetchName.removeFirst()
    let functionName = String(firstLetter).lowercased() + fetchName

    let fetcher = """
    \(functionName)(input: P.\(name).Input): Promise<Result<P.\(name).Output>> {
      return query<P.\(name).Input, P.\(name).Output>(input, `\(P.name)`);
    }
    """
    self = .init(decl: decl, fetcher: fetcher)
  }
}
