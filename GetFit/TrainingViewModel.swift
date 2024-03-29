import Foundation
import SwiftDate

struct TrainingViewModel {
  let workoutSession: WorkoutSession
}

extension TrainingViewModel: TrainingPresentable {

  var trainingTitle: String {
    return workoutSession.programName
  }

  var trainingInfo: String {
    return workoutSession.workoutName
  }

  var trainingExercisesCount: String {
    return "\(workoutSession.exercisesCount) exercises"
  }

  var trainingDurationString: String {
    return "\(workoutSession.duration) min".uppercased()
  }

  var trainingDateString: String {
    let date = workoutSession.date

    if date.isToday {
      return "TODAY"
    } else {
      return date.string(format: .custom("dd.MM.yyyy"))
    }
  }

  var completed: Bool {
    return workoutSession.completed
  }
}
