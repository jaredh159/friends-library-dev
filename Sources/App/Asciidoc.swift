import RomanNumeralKit

enum HtmlEntities: String {
  case leftDoubleQuote = "&#8220;"
  case rightDoubleQuote = "&#8221;"
  case leftSingleQuote = "&#8216;"
  case rightSingleQuote = "&#8217;"
  case mdash = "&#8212;"
  case ampersand = "&#38;"
  case ellipses = "&#8230;"
  case nonBreakingSpace = "&#160;"
}

enum Asciidoc {

  static func trimmedUtf8ShortDocumentTitle(_ title: String, lang: Lang) -> String {
    if lang == .en {
      return
        title
          .replacingOccurrences(
            of: #"^(The|A) "#,
            with: "",
            options: .regularExpression
          )
          .replacingOccurrences(
            of: #"^Selection from the (.*)"#,
            with: "$1 (Selection)",
            options: .regularExpression
          )
    }

    let shortTitle = utf8ShortTitle(title)
    if shortTitle.count < 25 { return shortTitle }

    return
      title
        .replacingOccurrences(
          of: #"^Selección de(l| la) (.*)"#,
          with: "$2 (Selección)",
          options: .regularExpression
        )
        .replacingOccurrences(
          of: #"^(El|La|Los|Una?) (?!(Camino|Verdad|Vida)\b)"#,
          with: "",
          options: .regularExpression
        )
  }

  static func utf8ShortTitle(_ title: String) -> String {
    htmlShortTitle(title)
      .replacingOccurrences(of: HtmlEntities.mdash.rawValue, with: "–")
      .replacingOccurrences(of: HtmlEntities.nonBreakingSpace.rawValue, with: " ")
  }

  static func htmlShortTitle(_ title: String) -> String {
    Asciidoc.htmlTitle(title)
      .replacingOccurrences(
        of: #"\bvolumen?\b "#,
        with: "Vol.\(HtmlEntities.nonBreakingSpace.rawValue)",
        options: [.regularExpression, .caseInsensitive]
      )
  }

  static func htmlTitle(_ title: String) -> String {
    var shortened = ""
    var number: String?

    // lol swift regexes... maybe look into https://github.com/crossroadlabs/Regex
    for (index, char) in title.enumerated() {
      switch (char.isNumber, number == nil, index == title.count - 1) {
        case (true, true, false):
          number = "\(char)"
        case (true, false, false):
          number! += "\(char)"
        case (true, true, true):
          shortened += toRoman("\(char)")
        case (false, true, _):
          shortened += "\(char)"
        case (false, false, _):
          shortened += toRoman(number) + "\(char)"
          number = nil
        case (true, false, true):
          number! += "\(char)"
          shortened += toRoman(number)
          number = nil
      }
    }
    return shortened.replacingOccurrences(of: "--", with: HtmlEntities.mdash.rawValue)
  }
}

private func toRoman(_ string: String?) -> String {
  guard let string = string else { return "" }
  if let int = Int(string),
     int < 1000, int != 160,
     let rn = try? RomanNumeral(from: int) {
    return rn.stringValue
  }
  return string
}
