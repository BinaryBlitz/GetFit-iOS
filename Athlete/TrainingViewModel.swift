//
//  TrainingViewModel.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 04/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Foundation

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
    let calendar = NSCalendar.currentCalendar()
    let dateCompnents = calendar.components([.Day, .Year, .Month], fromDate: training.date)
    let currentDateCompnents = calendar.components([.Day, .Year, .Month], fromDate: NSDate())
  
    if dateCompnents.day == currentDateCompnents.day &&
        dateCompnents.year == currentDateCompnents.year &&
        dateCompnents.month == currentDateCompnents.month {
      return "TODAY"
    } else {
      let formatter = NSDateFormatter()
      formatter.dateFormat = "dd/MM"
      return formatter.stringFromDate(training.date)
    }
  }
}

