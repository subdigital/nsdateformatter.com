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

  let formatter = NSDateFormatter()
  formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")

  // we'll do our best to guess at a date format
  formatter.dateStyle = .ShortStyle

  // if let _ = format.characters.indexOf(":") {
  //   formatter.timeStyle = .ShortStyle
  // } else {
  //   formatter.timeStyle = .NoStyle
  //

  if let date = formatter.dateFromString(dateString) {
    formatter.dateFormat = params["format"]
    let formattedString = formatter.stringFromDate(date)
    return renderJSON(["status": "ok", "result": formattedString, "date_string": dateString])
  } else {
    return renderJSON(["status": "invalid date"])
  }
}

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

  return stencil("index.html", context)
}
