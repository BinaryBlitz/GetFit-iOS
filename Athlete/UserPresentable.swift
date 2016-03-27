//
//  UserPresentable.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 23/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Foundation

protocol UserPresentable {
  var name: String { get }
  var info: String { get }
  var avatarURL: NSURL? { get }
  var coverImageURL: NSURL? { get }
}