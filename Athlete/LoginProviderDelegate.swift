//
//  LoginProviderDelegate.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 05/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

protocol LoginProviderDelegate {
  func loginProvider(loginProvider: LoginProvider, loggedInAs user: User)
  func loginProvider(loginProvider: LoginProvider, failedWith error: ErrorType)
}