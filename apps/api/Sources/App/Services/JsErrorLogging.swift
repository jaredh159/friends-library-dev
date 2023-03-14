import Foundation
import Graphiti
import Vapor

extension Resolver {
  func logJsError(
    req: Req,
    args: InputArgs<AppSchema.LogJsErrorDataInput>
  ) throws -> Future<GenericResponse> {
    future(of: GenericResponse.self, on: req.eventLoop) {
      await slackError(
        """
        **Runtime JS Error:**
        ```
        \(JSON.encode(args.input) ?? String(describing: args.input))
        ```
        """
      )
      return GenericResponse(success: true)
    }
  }
}

extension AppSchema {
  struct LogJsErrorDataInput: Codable {
    let userAgent: String
    let url: String
    let location: String
    let additionalInfo: String?
    let errorMessage: String?
    let errorName: String?
    let errorStack: String?
    let event: String?
    let source: String?
    let lineNumber: Int?
    let colNumber: Int?
  }

  static var logJsError: AppField<GenericResponse, InputArgs<LogJsErrorDataInput>> {
    Field("logJsError", at: Resolver.logJsError) {
      Argument("input", at: \.input)
    }
  }

  static var LogJsErrorDataInputType: AppInput<LogJsErrorDataInput> {
    Input(LogJsErrorDataInput.self) {
      InputField("userAgent", at: \.userAgent)
      InputField("url", at: \.url)
      InputField("location", at: \.location)
      InputField("additionalInfo", at: \.additionalInfo)
      InputField("errorMessage", at: \.errorMessage)
      InputField("errorName", at: \.errorName)
      InputField("errorStack", at: \.errorStack)
      InputField("event", at: \.event)
      InputField("source", at: \.source)
      InputField("lineNumber", at: \.lineNumber)
      InputField("colNumber", at: \.colNumber)
    }
  }
}
