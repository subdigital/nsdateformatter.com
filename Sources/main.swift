import Frank
import Stencil
import Inquiline
import Foundation

post("format") { request in
  guard let body = request.body else { return Response(.BadRequest, body: "Missing body") }

  let params = parseParams(body)

  guard let format = params["format"] else {
    return renderJSON(["status": "invalid", "error": "format is required"], status: .UnprocessableEntity)
  }

  guard let dateString = params["date"] else {
    return renderJSON(["status": "invalid", "error": "date is required"], status: .UnprocessableEntity)
  }

  let localeIdentifier = params["locale"] ?? "en_US_POSIX"

  let formatter = NSDateFormatter()
  formatter.locale = NSLocale(localeIdentifier: localeIdentifier)
  formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

  // Not yet implemented in OSS Swift
  // if let offset = params["time_zone_offset"] {
  //   let secondsPerHour = 60 * 60
  //   let offsetInSeconds = Int((Float(offset) ?? 0) * (Float(secondsPerHour) ?? 0))
  //   let timeZone = NSTimeZone(forSecondsFromGMT: offsetInSeconds)
  //   formatter.timeZone = timeZone
  // }

  if let date = formatter.dateFromString(dateString) {
    // setLocalizedDateFormatFromTemplate is not yet implemented
    // formatter.setLocalizedDateFormatFromTemplate(format)
    formatter.dateFormat = format
    let formattedString = formatter.stringFromDate(date)
    return renderJSON(["status": "ok", "result": formattedString, "date_string": dateString])
  } else {
    return renderJSON(["status": "invalid date", "date_string": dateString])
  }
}

get { request in

  let formatter = NSDateFormatter()
  let localeIdentifier = "en_US_POSIX"
  let locale = NSLocale(localeIdentifier: localeIdentifier)
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

  formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
  context["example_date"] = formatter.stringFromDate(NSDate())

  let locales: [[String:String]] = NSLocale.availableLocaleIdentifiers().sort().map {
    // Stencil doesn't have Comparison operators so the only way is to check for
    // the presence of `locale.default` on the front end.
    var res = ["id" : $0]
    if $0 == localeIdentifier {
        res["default"] = "localeIdentifier"
    }
    return res
  }
  context["locales"] = locales

  return stencil("index.html", context)
}
