import Foundation
import CoreFoundation

// workaround a swift/linux bug that prevents Locale.availableLocales from working on Linux.
// https://bugs.swift.org/browse/SR-3634
func availableLocales() -> [String] {
  let cflocales = CFLocaleCopyAvailableLocaleIdentifiers()
  var results: [String] = []
  for obj in unsafeBitCast(cflocales, to: NSArray.self) {
    results.append(obj as! String)
  }
  return results
}
