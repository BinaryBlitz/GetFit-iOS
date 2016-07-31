import Foundation
import SwiftDate

struct TrainingViewModel {
  let training: WorkoutSession
}

extension TrainingViewModel: TrainingPresentable {
  
  var trainingTitle: String {
    return training.programName
  }
  
  var trainingInfo: String {
    return training.workoutName
  }
  
  var trainingExercisesCount: String {
    return "\(training.exercisesCount) exercises"
  }
  
  var trainingDurationString: String {
    return "\(training.duration) min".uppercaseString
  }
  
  var trainingDateString: String {
    let date = training.date
    
    if date.isInToday() {
      return "TODAY"
    } else {
      return date.toString(.Custom("dd/MM"))!
    }
  }
}
