import Foundation
import Vapor

class FormatAPIController: RouteCollection {
    
    // These identifiers match the CLDR calendar identifiers
    // https://github.com/unicode-org/icu/blob/main/icu4c/source/i18n/ucal.cpp#L694
    private let calendars = [
        "gregorian": Calendar.Identifier.gregorian,
        "japanese": .japanese,
        "buddhist": .buddhist,
        "roc": .republicOfChina,
        "persian": .persian,
        "islamic-civil": .islamicCivil,
        "islamic": .islamic,
        "hebrew": .hebrew,
        "chinese": .chinese,
        "indian": .indian,
        "coptic": .coptic,
        "ethiopic": .ethiopicAmeteMihret,
        "ethiopic-amete-alem": .ethiopicAmeteAlem,
        "iso8601": .iso8601,
        "islamic-umalqura": .islamicUmmAlQura,
        "islamic-tbla": .islamicTabular,
    ]
    
    func boot(routes: RoutesBuilder) throws {
        routes.get("info.json", use: infoJSON)
        routes.post("format.json", use: formatJSON)
    }
    
    func infoJSON(_ req: Request) async throws -> InfoResponse {
        InfoResponse(calendars: calendars.keys.sorted(by: <),
                     locales: Locale.availableIdentifiers.sorted(by: <),
                     timeZones: TimeZone.knownTimeZoneIdentifiers.sorted(by: <),
                     timeZoneDataVersion: TimeZone.timeZoneDataVersion)
    }
    
    func formatJSON(_ req: Request) async throws -> [FormatResponse] {
        let requests = try req.content.decode([FormatRequest].self)
        return try requests.map(processRequest)
    }
    
    private func processRequest(_ request: FormatRequest) throws -> FormatResponse {
        let locale = try resolveLocale(matching: request.locale)
        let calendar = try resolveCalendar(matching: request.calendar, fallback: locale)
        let timeZone = try resolveTimeZone(matching: request.timeZone, fallback: locale)
        
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.timeZone = timeZone
        formatter.locale = locale
        
        switch request.format {
            case .date(let date):
                formatter.dateStyle = date.dateFormatterStyle
                formatter.timeStyle = .none
            case .time(let time):
                formatter.dateStyle = .none
                formatter.timeStyle = time.dateFormatterStyle
            case .dateAndTime(let date, let time):
                formatter.dateStyle = date.dateFormatterStyle
                formatter.timeStyle = time.dateFormatterStyle
            case .template(let string):
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: string, options: 0, locale: locale)
            case .raw(let string):
                formatter.dateFormat = string
        }
        
        let date: Date
        if let timestamp = request.timestamp {
            date = Date(timeIntervalSince1970: timestamp)
        } else {
            date = Date()
        }
        
        let formatted = formatter.string(from: date)
        let calendarIDName = calendars.first(where: { $0.value == calendar.identifier })?.key ?? "gregorian"
        
        return FormatResponse(
            id: request.id,
            calendar: calendarIDName,
            timeZone: timeZone.identifier,
            locale: locale.identifier,
            timestamp: date.timeIntervalSince1970,
            format: formatter.dateFormat,
            value: formatted
        )
    }
    
    private func resolveLocale(matching identifier: String?) throws -> Locale {
        if let identifier {
            let loweredLocaledID = identifier.lowercased()
            guard let actualLocaleID = Locale.availableIdentifiers.first(where: { $0.lowercased() == loweredLocaledID }) else {
                throw Abort(.badRequest, reason: "Unknown locale: '\(identifier)'")
            }
            return Locale(identifier: actualLocaleID)
        } else {
            return Locale(identifier: "en_US_POSIX")
        }
    }
    
    private func resolveCalendar(matching identifier: String?, fallback: Locale) throws -> Calendar {
        if let identifier {
            let loweredCalID = identifier.lowercased()
            guard let calendarIdentifier = self.calendars.first(where: { $0.key.lowercased() == loweredCalID })?.value else {
                throw Abort(.badRequest, reason: "Unknown calendar: '\(identifier)'")
            }
            return Calendar(identifier: calendarIdentifier)
        } else {
            return fallback.calendar
        }
    }
    
    private func resolveTimeZone(matching identifier: String?, fallback: Locale) throws -> TimeZone {
        if let identifier {
            let loweredTZID = identifier.lowercased()
            guard let actualTZID = TimeZone.knownTimeZoneIdentifiers.first(where: { $0.lowercased() == loweredTZID }) else {
                throw Abort(.badRequest, reason: "Unknown time zone: '\(identifier)'")
            }
            return TimeZone(identifier: actualTZID)!
        } else {
            if #available(macOS 13, *) {
                return fallback.timeZone ?? TimeZone(secondsFromGMT: 0)!
            } else {
                return TimeZone(secondsFromGMT: 0)!
            }
        }
    }
}

/// A request to format a timestamp
///
/// Valid JSON requests can look like:
///
/// ```json
/// // format the current date in the default locale, calendar, and time zone
/// { 
///   "format": { "date": "full" }
/// }
///
/// // format a specific point in time according to a specific locale,
/// // calendar, and time zone using a template format
/// {
///  "locale": "en_US",
///  "calendar": "japanese",
///  "timeZone": "africa/addis_ababa",
///  "timestamp": 1234567890.987,
///  "format": { "template": "yMMMdHHmmss" }
/// }
///
/// // format a specific point in time using the default locale and calendar,
/// // but in the New York time zone and using an ISO 8601-like format.
/// {
///  "id": "an-id-from-my-app",
///  "timeZone": "America/New_York",
///  "timestamp": 1708705211,
///  "format": { "raw": "y-MM-dd'T'HH:mm:ss.SSSX" }
/// }
/// ```
struct FormatRequest: Content {
    
    /// A client-provided identifier for the request.
    ///
    /// This value is returned as-is in the ``FormatResponse``. The purpose of this identifier is to help clients
    /// associate the responses with their requests. For example, this id might correspond to the `id="…"` value
    /// of an HTML element, or some other view identifier.
    let id: String?
    
    /// The identifier of the locale to use for the request (case insensitive)
    ///
    /// Valid values can be retrieved from the `/info.json` endpoint and are strings like `"en_US"`, `"se_NO"`, etc.
    /// If this value is omitted, then the `en_US_POSIX` locale is used.
    let locale: String?
    
    /// The identifier of the calendar to use for the request (case insensitive)
    ///
    /// Valid values can be retrieved from the `/info.json` endpoint and are strings like `"gregorian"`, `"japanese"`, etc.
    /// If this value is omitted, then the calendar of the `locale` is used. If the locale does not specify a calendar, then `"gregorian"` is used.
    let calendar: String?
    
    /// The identifier of the time zone to use for the request (case insensitive)
    ///
    /// These identifiers are ones such as `"America/Los_Angeles"` or `"Europe/Stockholm"`. There is no support for passing
    /// a time zone *offset*, since such time zones result in "fixed" time zones with no notion of Daylight Saving Time. By using the time zone
    /// identifier, formatting requests account for proper DST shifts or time-zone-specific variations, such as `Pacific/Apia`'s missing 30 Dec 2011.
    ///
    /// If this value is omitted, then the locale's time zone is used, if it has one. If the locale does not have one, then GMT is used.
    let timeZone: String?
    
    /// The Unix timestamp to format into a string
    ///
    /// This value (of seconds since the 1970 Unix epoch) is used as the point in time for formatting. It can be omitted, in which case "now" is used.
    let timestamp: Double?
    
    /// The format of the "rendered" timestamp
    ///
    /// This is the only required parameter of a `FormatRequest`, since all others may be omitted to assume default values.
    /// Valid values for this parameter are things like:
    /// - `.date(.full)`: render the localized date portion of the timestamp using complete era, year, month, and day information
    /// - `.time(.short)`: render only the time of day portion of the timestamp using a localized abbreviated format.
    /// - `.dateAndTime(.medium, .medium)`: render the date and time of day information in the timestamp in a localized format
    /// - `.template("jmm")`: render the timestamp using the provided date format *template*. This value is localized by `DateFormatter`
    ///   using the resolved locale.
    /// - `.raw("HH:mm")`: render the timestamp using the provided date format.
    let format: Format
    
    enum Style: String, Codable {
        case full
        case long
        case medium
        case short
        
        var dateFormatterStyle: DateFormatter.Style {
            switch self {
                case .full: return .full
                case .long: return .long
                case .medium: return .medium
                case .short: return .short
            }
        }
    }
    
    enum Format: Codable {
        
        enum CodingKeys: CodingKey {
            case date
            case time
            case template
            case raw
        }
        
        case date(Style)
        case time(Style)
        case dateAndTime(Style, Style)
        case template(String)
        case raw(String)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: FormatRequest.Format.CodingKeys.self)
            let allKeys = container.allKeys
            
            if allKeys == [.date] {
                self = .date(try container.decode(Style.self, forKey: .date))
            } else if allKeys == [.date, .time] || allKeys == [.time, .date] {
                self = .dateAndTime(try container.decode(Style.self, forKey: .date),
                                    try container.decode(Style.self, forKey: .time))
            } else if allKeys == [.time] {
                self = .time(try container.decode(Style.self, forKey: .time))
            } else if allKeys == [.template] {
                self = .template(try container.decode(String.self, forKey: .template))
            } else if allKeys == [.raw] {
                self = .raw(try container.decode(String.self, forKey: .raw))
            } else {
                let keyNames = allKeys.map(\.stringValue)
                throw Abort(.badRequest, reason: "Invalid format options: '\(keyNames)'")
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
                case .date(let style):
                    try container.encode(style, forKey: .date)
                case .time(let style):
                    try container.encode(style, forKey: .time)
                case .dateAndTime(let d, let t):
                    try container.encode(d, forKey: .date)
                    try container.encode(t, forKey: .time)
                case .template(let t):
                    try container.encode(t, forKey: .template)
                case .raw(let r):
                    try container.encode(r, forKey: .raw)
            }
        }
    }
    
}

struct FormatResponse: Content {
    let id: String?
    let calendar: String
    let timeZone: String
    let locale: String
    let timestamp: Double
    let format: String
    let value: String
}

struct InfoResponse: Content {
    let calendars: Array<String>
    let locales: Array<String>
    let timeZones: Array<String>
    let timeZoneDataVersion: String
}
