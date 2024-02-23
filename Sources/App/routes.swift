import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: FormatterController())
    try app.register(collection: FormatAPIController())
}

