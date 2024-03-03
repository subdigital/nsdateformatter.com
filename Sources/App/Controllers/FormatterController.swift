import Vapor
import Leaf

struct FormatterController: RouteCollection {
    struct DateFormatExample: Codable {
        let format: String
        let value: String
    }

    struct ViewData: Content {
        let examples: [DateFormatExample]
        let locales: [String]
        let defaultLocale: String
        let inputDate: String
        let exampleFormat: String
        let exampleResult: String
    }

    func boot(routes: RoutesBuilder) {
        routes.get("viewData", use: renderViewData)
    }

    func renderViewData(_ req: Request) async throws -> ViewData {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: defaultLocaleIdentifier)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let inputDate = formatter.string(from: date)

        let examples = examples(for: date, formatter: formatter)

        let viewData = ViewData(
            examples: examples,
            locales: buildLocales(),
            defaultLocale: defaultLocaleIdentifier,
            inputDate: inputDate,
            exampleFormat: examples.first?.format ?? "MMM yyyy",
            exampleResult: examples.first?.value ?? ""
        )

        return viewData
    }

    private let defaultLocaleIdentifier = "en_US_POSIX"

    private func buildLocales() -> [String] {
        Locale.availableIdentifiers.sorted() 
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

