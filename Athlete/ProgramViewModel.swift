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
    guard let trainer = program.trainer else {
      return nil
    }
    
    return NSURL(string: trainer.avatarURLString)
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
    return "free"
  }
  
  var category: String {
    return program.type.rawValue
  }
  
  var exercisesCount: String {
    return "10 exercises"
  }
  
  var description: String {
    return program.programDescription
  }
  
  var followers: String {
    return String(100)
  }
  
  var rating: String {
    return String(4.7)
  }
  
  var duration: String {
    return "40 MIN"
  }
  
  var bannerURL: NSURL? {
    return NSURL(string: program.bannerURLString)
  }
}