import XCTVapor
import XExpect

@testable import App

final class ContactFormTests: AppTestCase {
  func testSubmitContactFormEnglish() async throws {
    Current.date = { Date(timeIntervalSinceReferenceDate: 0) }

    let output = try await SubmitContactForm.resolve(
      with: .init(
        lang: .en,
        name: "Bob Villa",
        email: "bob@thisoldhouse.com",
        subject: .tech,
        message: "hey there"
      ),
      in: .mock
    )

    expect(output).toEqual(.success)
    let email = sent.emails.first
    XCTAssertEqual(sent.emails.count, 1)
    XCTAssertEqual(email?.subject, "friendslibrary.com contact form -- \(Current.date())")
    XCTAssertEqual(email?.replyTo, .init(email: "bob@thisoldhouse.com", name: "Bob Villa"))
    XCTAssertEqual(email?.from, .init(email: "noreply@friendslibrary.com", name: "Friends Library"))
    XCTAssertContains(email?.text, "Name: Bob Villa")
    XCTAssertContains(email?.text, "Message: hey there")
    XCTAssertContains(email?.text, "Type: Website / technical question")
    XCTAssertEqual(email?.firstRecipient, .init(email: Env.JARED_CONTACT_FORM_EMAIL))
    XCTAssertEqual(sent.slacks.count, 1)
    XCTAssertTrue(sent.slacks.first?.message.text.hasPrefix("*Contact form submission:*") == true)
  }

  func testSubmitContactFormSpanish() async throws {
    Current.date = { Date(timeIntervalSinceReferenceDate: 0) }

    let _ = try await SubmitContactForm.resolve(
      with: .init(
        lang: .es,
        name: "Pablo Smith",
        email: "pablo@mexico.gov",
        subject: .other,
        message: "hola"
      ),
      in: .mock
    )

    let email = sent.emails.first
    XCTAssertEqual(sent.emails.count, 1)
    XCTAssertEqual(
      email?.subject,
      "bibliotecadelosamigos.org formulario de contacto -- \(Current.date())"
    )
    XCTAssertEqual(email?.replyTo, .init(email: "pablo@mexico.gov", name: "Pablo Smith"))
    XCTAssertEqual(
      email?.from,
      .init(email: "noreply@bibliotecadelosamigos.org", name: "Biblioteca de los Amigos")
    )
    XCTAssertContains(email?.text, "Name: Pablo Smith")
    XCTAssertContains(email?.text, "Message: hola")
    XCTAssertEqual(email?.firstRecipient, .init(email: Env.JASON_CONTACT_FORM_EMAIL))
    XCTAssertEqual(sent.slacks.count, 1)
    XCTAssertTrue(sent.slacks.first?.message.text.hasPrefix("*Contact form submission:*") == true)
  }
}
