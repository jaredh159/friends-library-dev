import TaggedTime

enum AudioUtil {
  enum HumanDurationStyle {
    case clock
    case abbrev(Lang)
  }

  static func humanDuration(partDurations: [Seconds<Double>], style: HumanDurationStyle) -> String {
    let (hours, minutes, seconds) = durationUnits(partDurations: partDurations)
    switch style {
    case .clock:
      let units = [hours, minutes, seconds]
      return units.enumerated()
        .filter { idx, num in num != 0 ? true : units[(idx + 1)...].allSatisfy { $0 == 0 } }
        .map { String($0.1) }
        .map { $0.padLeft(toLength: 2, withPad: "0") }
        .joined(separator: ":")
        .replace("^0", "")
    case .abbrev(let lang):
      var duration = minutes == 0 ? "" : " \(minutes) min"
      if hours > 0 {
        duration = "\(hours) \(lang == .en ? "hr" : "h")\(duration)"
      }
      return duration.trimmingCharacters(in: .whitespaces)
    }
  }
}

// helpers

private func durationUnits(partDurations: [Seconds<Double>])
  -> (hours: Int, minutes: Int, seconds: Int) {
  let totalSeconds = Int(partDurations.reduce(0, +).rawValue)
  let hours = totalSeconds / (60 * 60)
  let minutes = (totalSeconds - (hours * 60 * 60)) / 60
  let seconds = totalSeconds % 60
  return (hours, minutes, seconds)
}
