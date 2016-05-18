//
//  ProgramViewModel.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 03/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Foundation

struct ProgramViewModel {
  let program: Program
}

extension ProgramViewModel: TrainerPresentable {
  var trainerAvatarURL: NSURL? {
    guard let trainer = program.trainer, avatarURLString = trainer.avatarURLString else {
      return nil
    }
    
    return NSURL(string: avatarURLString)
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
  
  var bannerURL: NSURL? {
    return NSURL(string: program.bannerURLString)
  }
}