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
    }
  }

  public var parameterEncoding: ParameterEncoding {
    switch self {
    case .index, .show(_):
      return URLEncoding.default
    case .createPurchase(_):
      return JSONEncoding.default
    }
  }

  public var method: Moya.Method {
    switch self {
    case .index, .show(_):
      return .get
    case .createPurchase(_):
      return .post
    }
  }

  public var parameters: [String: Any]? {
    switch self {
    case .index(_):
      // TODO: Add real filter
      return ["order": "created_at" as Any]
    case .show(_):
      return nil
    case .createPurchase(_):
      return nil
    }
  }

}
