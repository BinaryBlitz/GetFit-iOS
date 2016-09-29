import Foundation
import Moya
import Moya_SwiftyJSONMapper
import Toucan

public struct ProgramsFilter {
  //TODO: Add filter paramters
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
  
  public var method: Moya.Method {
    switch self {
    case .index, .show(_):
      return .GET
    case .createPurchase(_):
      return .POST
    }
  }
  
  public var parameters: [String: Any]? {
    switch self {
    case .index(let filter):
      //TODO: Add real filter
      return ["order": "created_at"]
    case .show(_):
      return nil
    case .createPurchase(_):
      return nil
    }
  }
  
}
