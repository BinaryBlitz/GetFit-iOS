//
//  TrainerPresentable.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 22/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Foundation

protocol TrainerPresentable {
  var trainerAvatarURL: URL? { get }
  var trainerName: String { get }
}
