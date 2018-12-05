import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let formatterController = FormatterController()
    router.get(use: formatterController.index)
    router.post("format", use: formatterController.format)
}
