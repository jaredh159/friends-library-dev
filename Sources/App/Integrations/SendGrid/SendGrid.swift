import Foundation

enum SendGrid {
  struct EmailAddress: Encodable, ExpressibleByStringLiteral {
    let email: String
    let name: String?

    init(email: String, name: String? = nil) {
      self.email = email
      self.name = name
    }

    init(stringLiteral email: String) {
      self.email = email
      name = nil
    }
  }

  struct Email: Encodable {
    struct Personalization: Encodable {
      let to: [EmailAddress]
    }

    struct Attachment: Encodable {
      let content: Base64EncodedString
      let filename: String
      var type = "text/plain"

      init(content: Base64EncodedString, filename: String) {
        self.content = content
        self.filename = filename
      }

      init(data: Data, filename: String) throws {
        content = try Base64EncodedString(data: data)
        self.filename = filename
      }
    }

    let personalizations: [Personalization]
    let from: EmailAddress
    let subject: String
    let content: [[String: String]]
    var attachments: [Attachment]?

    init(to: EmailAddress, from: EmailAddress, subject: String, html: String) {
      personalizations = [Personalization(to: [to])]
      self.from = from
      self.subject = subject
      content = [
        ["type": "text/html", "value": html],
      ]
    }
  }
}

extension SendGrid.EmailAddress {
  static let friendsLibrary: Self = .init(
    email: "notifications@graphql-api.friendslibrary.com",
    name: "Friends Library"
  )
}
