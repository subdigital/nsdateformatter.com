import PathKit
import Frank
import Foundation
import Inquiline

func renderFile(path: String, contentType: String) -> ResponseConvertible {
  do {
    let filePath = Path("Resources") + Path(path)
    let contents: String = try filePath.read()
    let headers = [("Content-Type", contentType) ]
    return Response(.Ok, headers: headers, body: contents)
  } catch {
    return Response(.InternalServerError)
  }
}
