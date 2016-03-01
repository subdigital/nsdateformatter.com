import PathKit
import Stencil
import Inquiline
import Frank

func stencil(path: String, _ context: [String: Any] = [:]) -> ResponseConvertible {
  do {
    let template = try Template(path: Path("Resources") + Path(path))
    let body = try template.render(Context(dictionary: context))
    return Response(.Ok, headers: [("Content-Type", "text/html")], body: body)
  } catch {
    print("Error rendering template: \(path)")
    return Response(.InternalServerError)
  }
}
