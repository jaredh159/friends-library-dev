import Graphiti
import Vapor
import XCore
import XSendGrid

extension Resolver {
  func submitContactForm(
    req: Req,
    args: InputArgs<AppSchema.SubmitContactFormInput>
  ) throws -> Future<GenericResponse> {
    let email = SendGrid.Email(
      to: args.input |> emailTo,
      from: EmailBuilder.fromAddress(lang: args.input.lang),
      replyTo: .init(email: args.input.email, name: args.input.name),
      subject: args.input.lang |> subject,
      text: args.input |> emailBody
    )
    return future(of: GenericResponse.self, on: req.eventLoop) {
      try await Current.sendGridClient.send(email)
      await slackInfo(
        """
        *Contact form submission:*
        _Name:_ \(args.input.name)
        _Email:_ \(args.input.email)
        _Message:_ \(args.input.message)
        """
      )
      return GenericResponse(success: true)
    }
  }
}

// helpers

private func emailBody(_ input: AppSchema.SubmitContactFormInput) -> String {
  var lines = ["Name: \(input.name)"]
  if input.subject == .tech {
    lines.append("Type: Website / technical question")
  }
  lines.append("Message: \(input.message)")
  return lines.joined(separator: "\n")
}

private func emailTo(_ input: AppSchema.SubmitContactFormInput) -> SendGrid.EmailAddress {
  let jared = SendGrid.EmailAddress(email: Env.JARED_CONTACT_FORM_EMAIL)
  let jason = SendGrid.EmailAddress(email: Env.JASON_CONTACT_FORM_EMAIL)

  if input.lang == .es || input.message.lowercased().contains("jason") {
    return jason
  }

  if input.subject == .tech || input.message.lowercased().contains("jared") {
    return jared
  }

  return Bool.random() ? jared : jason
}

private func subject(_ lang: Lang) -> String {
  let start = lang == .en
    ? "friendslibrary.com contact form"
    : "bibliotecadelosamigos.org formulario de contacto"
  return start + " -- \(Current.date())"
}

// schema types

extension AppSchema {
  struct SubmitContactFormInput: Codable {
    enum Subject: String, Codable, CaseIterable {
      case tech
      case other
    }

    let lang: Lang
    let name: String
    let email: String
    let subject: Subject
    let message: String
  }

  static var submitContactForm: AppField<GenericResponse, InputArgs<SubmitContactFormInput>> {
    Field("submitContactForm", at: Resolver.submitContactForm) {
      Argument("input", at: \.input)
    }
  }

  static var SubmitContactFormInputType: AppInput<SubmitContactFormInput> {
    Input(SubmitContactFormInput.self) {
      InputField("lang", at: \.lang)
      InputField("name", at: \.name)
      InputField("email", at: \.email)
      InputField("subject", at: \.subject)
      InputField("message", at: \.message)
    }
  }
}
