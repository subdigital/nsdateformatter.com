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
        let formats: [DateFormatExample]
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
    }

    func index(_ req: Request) async throws -> View {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: defaultLocaleIdentifier)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let inputDate = formatter.string(from: date)

        let examples = examples(for: date, formatter: formatter)

        let viewData = ViewData(
            formats: examples,
            locales: buildLocales(),
            inputDate: inputDate,
            exampleFormat: examples.first?.format ?? "MMM yyyy",
            exampleResult: examples.first?.value ?? ""
        )

        return try await req.view.render("index", viewData)
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

