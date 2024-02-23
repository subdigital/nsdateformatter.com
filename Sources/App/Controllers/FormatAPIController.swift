import Foundation
import Vapor

class FormatAPIController: RouteCollection {
    
    private let calendars = [
        "gregorian": Calendar(identifier: .gregorian),
        "buddhist": Calendar(identifier: .buddhist),
        "chinese": Calendar(identifier: .chinese),
        "coptic": Calendar(identifier: .coptic),
        "ethiopicAmeteMihret": Calendar(identifier: .ethiopicAmeteMihret),
        "ethiopicAmeteAlem": Calendar(identifier: .ethiopicAmeteAlem),
        "hebrew": Calendar(identifier: .hebrew),
        "iso8601": Calendar(identifier: .iso8601),
        "indian": Calendar(identifier: .indian),
        "islamic": Calendar(identifier: .islamic),
        "islamicCivil": Calendar(identifier: .islamicCivil),
        "japanese": Calendar(identifier: .japanese),
        "persian": Calendar(identifier: .persian),
        "republicOfChina": Calendar(identifier: .republicOfChina),
        "islamicTabular": Calendar(identifier: .islamicTabular),
        "islamicUmmAlQura": Calendar(identifier: .islamicUmmAlQura)
    ]
    
    func boot(routes: RoutesBuilder) throws {
        routes.post("format.json", use: formatJSON)
    }
    
    func formatJSON(_ req: Request) async throws -> [FormatResponse] {
        let requests = try req.content.decode([FormatRequest].self)
        return try requests.map(processRequest)
    }
    
    private func processRequest(_ request: FormatRequest) throws -> FormatResponse {
        let locale: Locale
        let calendar: Calendar
        let calendarID: String
        let timeZone: TimeZone
        
        if let localeID = request.locale {
            let loweredLocaledID = localeID.lowercased()
            guard let actualLocaleID = Locale.availableIdentifiers.first(where: { $0.lowercased() == loweredLocaledID }) else {
                throw Abort(.badRequest, reason: "Unknown locale: '\(localeID)'")
            }
            locale = Locale(identifier: actualLocaleID)
        } else {
            locale = Locale(identifier: "en_US_POSIX")
        }
        
        if let tzID = request.timeZone {
            let loweredTZID = tzID.lowercased()
            guard let actualTZID = TimeZone.knownTimeZoneIdentifiers.first(where: { $0.lowercased() == loweredTZID }) else {
                throw Abort(.badRequest, reason: "Unknown time zone: '\(tzID)'")
            }
            timeZone = TimeZone(identifier: actualTZID)!
        } else {
            if #available(macOS 13, *) {
                if let tz = locale.timeZone {
                    timeZone = tz
                } else {
                    timeZone = TimeZone(secondsFromGMT: 0)!
                }
            } else {
                timeZone = TimeZone(secondsFromGMT: 0)!
            }
        }
        
        if let calID = request.calendar {
            guard let c = self.calendars[calID] else {
                throw Abort(.badRequest, reason: "Unknown calendar: '\(calID)'")
            }
            calendar = c
            calendarID = calID
        } else {
            calendar = locale.calendar
            calendarID = "\(calendar.identifier)"
        }
        
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
        
        return FormatResponse(id: request.id,
                              calendar: calendarID,
                              timeZone: timeZone.identifier,
                              locale: locale.identifier,
                              timestamp: date.timeIntervalSince1970,
                              format: formatter.dateFormat,
                              value: formatted)
    }
}

struct FormatRequest: Content {
    let id: String?
    let calendar: String?
    let timeZone: String?
    let locale: String?
    let timestamp: Double?
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
