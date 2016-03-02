import Foundation

func parseParams(htmlBody: String) -> [String: String] {
  let parts = htmlBody.componentsSeparatedByString("&")

  print("html body: \(htmlBody)")

  var params = [String:String]()
  for keyValuePair in parts {
    let components = keyValuePair.componentsSeparatedByString("=")
    let key = components[0].stringByRemovingPercentEncoding!
    let value = components[1].stringByRemovingPercentEncoding!.stringByReplacingOccurrencesOfString("+", withString: " ")
    params[key] = value
  }

  print("params: \(params)")


  return params
}
