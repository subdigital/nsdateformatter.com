import Frank
import Stencil
import Foundation

get { request in

  let formatter = NSDateFormatter()
  let locale = NSLocale(localeIdentifier: "en_US_POSIX")
  formatter.locale = locale
  let date = NSDate()
  let formats = [
    "EEEE, MMM d, yyyy",
    "MM/dd/yyyy",
    "MM-dd-yyyy HH:mm",
    "MMM d, H:mm a",
    "MMMM yyyy",
    "MMM d, yyyy",
    "E, d MMM yyyy HH:mm:ss Z",
    "yyyy-MM-dd'T'HH:mm:ssZ",
    "dd.MM.yy"
  ]

  let examples: [[String:String]] = formats.map { format in
    formatter.dateFormat = format
    let formatExample: [String: String] = [
      "format": format,
      "value": formatter.stringFromDate(date)
    ]
    return formatExample
  }

  var context = [String : Any]()
  context["formats"] = examples

  return stencil("index.stencil", context)
}
