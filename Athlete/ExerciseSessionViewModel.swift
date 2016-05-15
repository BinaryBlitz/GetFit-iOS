//
//  ExerciseSessionViewModel.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 05/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

struct ExerciseSessionViewModel {
  let exerciseSession: ExerciseSession
}

extension ExerciseSessionViewModel: ExerciseSessionPresentable {
  var exerciseName: String {
    return exerciseSession.name ?? ""
  }
  
  var repetitions: String? {
    let reps = exerciseSession.reps
    guard reps > 0 else { return nil }
    return "\(reps) times".uppercaseString
  }
  
  var weight: String? {
    let weight = exerciseSession.weight
    guard weight > 0 else { return nil }
    return "\(weight) kg".uppercaseString
  }
  
  var distance: String? {
    let dist = exerciseSession.distance
    guard dist > 0 else { return nil }
    return "\(dist) m".uppercaseString
  }
  
  var sets: String? {
    return "\(exerciseSession.sets)"
  }
  
  var completed: Bool {
    return exerciseSession.completed
  }
}
