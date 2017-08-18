import Foundation
import Moya
import Moya_SwiftyJSONMapper
import Toucan

public struct ProgramsFilter {
  // TODO: Add filter paramters
}

extension GetFit {

  public enum Programs {
    case index(filter: ProgramsFilter)
    case show(id: Int)
    case createRating(programId: Int, value: Int, content: String)
    case createPurchase(programId: Int)
  }

}

extension GetFit.Programs: TargetType {

  public var path: String {
    switch self {
    case .index(_):
      return "/programs"
    case .show(let id):
      return "/programs/\(id)"
    case .createPurchase(let programId):
      return "/programs/\(programId)/purchase"
    case .createRating(let programId, _,_):
      return "/programs/\(programId)/ratings"
    }
  }

  public var parameterEncoding: ParameterEncoding {
    return JSONEncoding.default
  }

  public var method: Moya.Method {
    switch self {
    case .index, .show(_):
      return .get
    case .createPurchase(_), .createRating(_,_,_):
      return .post
    }
  }

  public var parameters: [String: Any]? {
    switch self {
    case .index(_):
      // TODO: Add real filter
      return ["order": "created_at" as Any]
    case .createRating(_, let value, let content):
      let rating = ["value": value as Any, "content": content as Any]
      return ["rating": rating as Any]
    case .show(_):
      return nil
    case .createPurchase(_):
      return nil
    }
  }

}
