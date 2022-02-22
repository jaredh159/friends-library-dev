import Foundation

enum EmailBuilder {
  static func fromAddress(lang: Lang) -> SendGrid.EmailAddress {
    lang == .en
      ? .init(email: "noreply@friendslibrary.com", name: "Friends Library")
      : .init(email: "noreply@bibliotecadelosamigos.org", name: "Biblioteca de los Amigos")
  }
}
