import Foundation
import Moya
import Moya_SwiftyJSONMapper
import Toucan

extension GetFit {
  
  public enum Trainers {
    case Index(filter: TrainersFilter)
    case Show(id: Int)
    case Programs(trainerId: Int)
  }
  
}

extension GetFit.Trainers: TargetType {
  
  public var path: String {
    switch self {
    case .Index(_):
      return "/trainers"
    case .Show(let id):
      return "/trainers/\(id)"
    case .Programs(let trainerId):
      return "/trainers/\(trainerId)/programs"
    }
  }
  
  public var method: Moya.Method {
    return .GET
  }
  
  public var parameters: [String: AnyObject]? {
    switch self {
    case .Index(let filter):
      return ["category": filter.category.rawValue]
    case .Show(_), .Programs(_):
      return nil
    }
  }
  
}