//
//  ProgramPresentable.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 03/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Foundation

protocol ProgramPresentable {
  var title: String { get }
  var price: String { get }
  var category: String { get }
  var exercisesCount: String { get }
  var description: String { get }
  var followers: String { get }
  var rating: String { get }
  var duration: String { get }
  var bannerURL: NSURL? { get }
}