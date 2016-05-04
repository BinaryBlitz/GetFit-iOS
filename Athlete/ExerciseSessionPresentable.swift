//
//  ExerciseSessionPresentable.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 05/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

protocol ExerciseSessionPresentable {
  var exerciseName: String { get }
  var repetitions: String? { get }
  var weight: String? { get }
  var distance: String? { get }
  var sets: String? { get }
  var completed: Bool { get }
}

