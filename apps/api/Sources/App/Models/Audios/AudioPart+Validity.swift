extension AudioPart {
  var isValid: Bool {
    // while recording sewel chapter by chapter, we have a 25 second
    // "note to the listener" which is special cased, because it is so small
    let isTempNoteToListener = title == "Nota para el oyente"

    if !isTempNoteToListener, mp3SizeHq < 2_000_000, mp3SizeHq != 0 {
      return false
    }

    if !isTempNoteToListener, mp3SizeLq < 1_000_000, mp3SizeLq != 0 {
      return false
    }

    if mp3SizeLq == mp3SizeHq, mp3SizeHq != 0 {
      return false
    }

    if mp3SizeLq >= mp3SizeHq, mp3SizeLq != 0 {
      return false
    }

    if externalIdHq < 200_000_000, externalIdHq != 0 {
      return false
    }

    if externalIdLq < 200_000_000, externalIdLq != 0 {
      return false
    }

    if isPublished, duration < 200 {
      return false
    }

    if title.isEmpty || title.containsUnpresentableSubstring {
      return false
    }

    if order < 1 {
      return false
    }

    if !chapters.allSatisfy({ $0 >= 0 }) {
      return false
    }

    var prevChapter = chapters.first - 1
    for chapter in chapters {
      if chapter != prevChapter + 1 {
        return false
      }
      prevChapter = chapter
    }

    return true
  }
}
