import Vapor
import Leaf

final class FormatterController {
    
    struct DateFormatExample: Codable {
        let format: String
        let value: String
    }
    
    struct LocaleOption : Codable {
        let identifier: String
        let isDefault: Bool
    }
    
    struct ViewData : Codable {
        let formats: [DateFormatExample]
        let locales: [LocaleOption]
        let exampleDate: String
    }
    
    struct FormatResult : Content {
        let status: String
        let result: String
    }
    
    func index(_ req: Request) throws -> Future<View> {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: defaultLocaleIdentifier)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let exampleDate = formatter.string(from: date)
        
        let context = ViewData(formats: examples(for: date, formatter: formatter),
                               locales: locales(),
                               exampleDate: exampleDate)
        
        return try req.view().render("index.leaf", context)
    }
    
    func format(_ req: Request) throws -> FormatResult {
        guard let dateInput = (try req.content.syncGet(String.self, at: "date")).removingPercentEncoding else {
            throw Abort(.badRequest, headers: [:], reason: "Invalid date parameter", identifier: nil, suggestedFixes: [])
        }
        let format: String = try req.content.syncGet(at: "format")
        let localeIdentifier: String = (try? req.content.syncGet(at: "locale")) ?? defaultLocaleIdentifier
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = formatter.date(from: dateInput) else {
            return FormatResult(status: "invalid date", result: "")
        }
        
        formatter.dateFormat = format
        let result = formatter.string(from: date)
        return FormatResult(status: "ok", result: result)
    }
    
    private var defaultLocaleIdentifier: String {
        return "en_US_POSIX"
    }

    private func locales() -> [LocaleOption] {
        return Locale.availableIdentifiers.sorted().map { id in
            return LocaleOption(identifier: id, isDefault: id == defaultLocaleIdentifier)
        }
    }
    
    private func examples(for date: Date, formatter: DateFormatter) -> [DateFormatExample] {
        return exampleFormats().map { format in
            formatter.dateFormat = format
            let value = formatter.string(from: date)
            return DateFormatExample(format: format, value: value)
        }
    }
    
    private func exampleFormats() -> [String] {
        return [
            "EEEE, MMM d, yyyy",
            "MM/dd/yyyy",
            "MM-dd-yyyy HH:mm",
            "MMM d, h:mm a",
            "MMMM yyyy",
            "MMM d, yyyy",
            "E, d MMM yyyy HH:mm:ss Z",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "dd.MM.yy",
            "HH:mm:ss.SSS"
        ]
    }
}
