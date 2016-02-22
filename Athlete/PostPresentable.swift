//
//  PostPresentable.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 22/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

protocol PostPresentable {
  var text: String { get }
  var imageURL: NSURL? { get }
  var likesCount: String { get }
  var commentsCount: String { get }
}