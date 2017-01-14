import Vapor
import Foundation

let drop = Droplet()


let exampleFormats = [
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


drop.get { req in
    let formatter = DateFormatter()
    let defaultLocaleIdentifier = "en_US_POSIX"
    let locale = Locale(identifier: defaultLocaleIdentifier)
    formatter.locale = locale
    let date = Date()

    let examples: [Node] = exampleFormats.map { format in
        formatter.dateFormat = format
        let formatExample: [String: Node] = [
            "format": Node.string(format),
            "value": Node.string(formatter.string(from: date))
        ]
        return Node.object(formatExample)
    }

    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

    let locales = availableLocales().sorted()
    let localeNodes: [Node] = locales.map { locale in

      var res = ["id" : Node.string(locale)]

      // set a default flag so the UI knows which select
      if locale == defaultLocaleIdentifier {
          res["default"] = Node.string("localeIdentifier")
      }

      return Node.object(res)
    }

    let dateString = formatter.string(from: Date())
    let context = Node.object([
      "example_date": Node.string(dateString),
      "locales": Node.array(localeNodes),
      "formats": Node.array(examples)
    ])

    return try drop.view.make("index", context)
}

drop.post("format") { req in

    guard let format = req.data["format"]?.string,
        let dateString = req.data["date"]?.string?.removingPercentEncoding,
        let timeZoneOffset = req.data["time_zone_offset"]?.int

    else {
      throw Abort.badRequest
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    formatter.locale = Locale(identifier: req.data["locale"]?.string ?? "en_US_POSIX")
    if let date = formatter.date(from: dateString) {
        formatter.dateFormat = format
        let formattedString = formatter.string(from: date)
        return try JSON(node: [
            "status": "ok",
            "result": formattedString
        ])
    } else {
        return try JSON(node: ["status": "invalid format"])
    }
}

drop.run()
