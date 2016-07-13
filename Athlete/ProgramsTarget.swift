import Foundation
import Moya
import Moya_SwiftyJSONMapper
import Toucan

public struct ProgramsFilter {
  //TODO: Add filter paramters
}

extension GetFit {
  
  public enum Programs {
    case Index(filter: ProgramsFilter)
    case Show(id: Int)
    case CreatePurchase(programId: Int)
  }
  
}

extension GetFit.Programs: TargetType {
  
  public var path: String {
    switch self {
    case .Index(_):
      return "/programs"
    case .Show(let id):
      return "/programs/\(id)"
    case .CreatePurchase(let programId):
      return "/programs/\(programId)/purchase"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .Index, .Show(_):
      return .GET
    case .CreatePurchase(_):
      return .POST
    }
  }
  
  public var parameters: [String: AnyObject]? {
    switch self {
    case .Index(let filter):
      //TODO: Add real filter
      return ["order": "created_at"]
    case .Show(_):
      return nil
    case .CreatePurchase(_):
      return nil
    }
  }
  
}