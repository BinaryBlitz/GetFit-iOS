//
//  TrainingPresentable.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 04/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

protocol TrainingPresentable {
  var trainingTitle: String { get }
  var trainingCategory: String { get }
  var trainingExercisesCount: String { get }
  var trainingDurationString: String { get }
  var trainingDateString: String { get }
}
