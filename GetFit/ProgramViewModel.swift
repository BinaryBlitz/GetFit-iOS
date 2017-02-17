import Foundation
import UIKit

struct ProgramViewModel {
  let program: Program
}

extension ProgramViewModel: TrainerPresentable {
  var trainerAvatarURL: URL? {
    guard let trainer = program.trainer, let avatarURLString = trainer.avatarURLString else {
      return nil
    }
    
    return URL(string: avatarURLString)
  }
  
  var trainerName: String {
    guard let trainer = program.trainer else {
      return ""
    }
    
    return "\(trainer.firstName) \(trainer.lastName)"
  }
}

extension ProgramViewModel: ProgramPresentable {
  var title: String {
    return program.name
  }
  
  var price: String {
    if program.price == 0 {
      return "free"
    }
    
    return "$\(program.price)"
  }
  
  var category: String {
    return program.type
  }
  
  var workoutsCount: String {
    return "\(program.workoutsCount) workouts"
  }
  
  var description: String {
    return program.programDescription
  }
  
  var preview: String {
    return program.programPreview
  }
  
  var followers: String {
    return String(100)
  }
  
  var rating: String {
    return String(4.7)
  }
  
  var duration: String {
    return "\(program.duration) MIN"
  }
  
  var bannerURL: URL? {
    guard let urlString = program.bannerURLString else { return nil }
    return URL(string: urlString)
  }
  
  var info: NSAttributedString {
    let infoFontSize: CGFloat = 15
    let boldTextAttrebutes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: infoFontSize)]
    
    return NSMutableAttributedString(string: workoutsCount, attributes: boldTextAttrebutes)
  }
}
