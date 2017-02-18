import SwiftyJSON

protocol JSONSerializable {
  init?(json: JSON)
  func convertToJSON() -> JSON
}

extension JSONSerializable {

  func convertToJSON() -> JSON {
    return JSON.null
  }
}
