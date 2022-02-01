import Vapor
import Leaf

struct FormatterController: RouteCollection {

    struct DateFormatExample: Codable {
        let format: String
        let value: String
    }

    struct LocaleOption: Codable {
        let identifier: String
        let isDefault: Bool
    }

    struct ViewData: Codable {
        let examples: [DateFormatExample]
        let locales: [LocaleOption]
        let inputDate: String
        let exampleFormat: String
        let exampleResult: String
    }

    struct FormatResult: Codable {
        let status: String
        let result: String
    }

    func boot(routes: RoutesBuilder) {
        routes.get(use: index)
        routes.post("format", use: format)
    }

    func index(_ req: Request) async throws -> View {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: defaultLocaleIdentifier)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let inputDate = formatter.string(from: date)

        let examples = examples(for: date, formatter: formatter)

        let viewData = ViewData(
            examples: examples,
            locales: buildLocales(),
            inputDate: inputDate,
            exampleFormat: examples.first?.format ?? "MMM yyyy",
            exampleResult: examples.first?.value ?? ""
        )

        return try await req.view.render("index", viewData)
    }

    func format(_ req: Request) async throws -> String {
        struct FormatRequest: Codable {
            let date: String
            let format: String
            let timezoneOffset: Float
            let locale: String
        }

        let fr = try req.content.decode(FormatRequest.self)
        req.logger.info("Format request: \(fr)")


        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd'T'HH:mm"
        formatter.timeZone = .init(secondsFromGMT: Int(fr.timezoneOffset * 60 * 60))

        guard let dateInput = fr.date.removingPercentEncoding,
              let sourceDate = formatter.date(from: dateInput) else {
            throw Abort(.badRequest)
        }

        formatter.locale = Locale(identifier: fr.locale)
        formatter.dateFormat = fr.format

        let value = formatter.string(from: sourceDate)
        return value
    }

    private let defaultLocaleIdentifier = "en_US_POSIX"

    private func buildLocales() -> [LocaleOption] {
        Locale.availableIdentifiers.sorted().map { id in 
            LocaleOption(identifier: id, isDefault: id == defaultLocaleIdentifier)
        }
    }

    private func examples(for date: Date, formatter: DateFormatter) -> [DateFormatExample] {
        exampleFormats().map { format in
            formatter.dateFormat = format
            let value = formatter.string(from: date)
            return DateFormatExample(format: format, value: value)
        }
    }

    private func exampleFormats() -> [String] {
        [
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

