//
//  LoginViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 10/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import VK_ios_sdk
import SwiftSpinner
import SwiftyJSON

typealias Spinner = SwiftSpinner

class LoginViewController: UIViewController {

  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var facebookButton: LoginButton!
  @IBOutlet weak var vkButton: LoginButton!
  @IBOutlet weak var phoneButton: LoginButton!
  
  let loginProvider = APIProvider<GetFit.Login>()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    backgroundImageView.image = UIImage(named: "LoginBG")
    let overlay = UIView(frame: backgroundImageView.frame)
    overlay.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.51)
    backgroundImageView.addSubview(overlay)
    
    facebookButton.text = "facebook".uppercaseString
    vkButton.text = "vkontakte".uppercaseString
    phoneButton.text = "phone".uppercaseString
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    navigationController?.navigationBarHidden = true
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  //MARK: - Actions
  
  @IBAction func facebookButtonAction(sender: AnyObject) {
    let fbLoginManager = FBSDKLoginManager()
    fbLoginManager.loginBehavior = FBSDKLoginBehavior.Browser
    fbLoginManager.logInWithReadPermissions(["public_profile"], fromViewController: self) { (result, error) in
      guard error == nil else {
        print(error)
        Spinner.hide()
        self.presentAlertWithMessage("Не удалось войти через Facebook")
        return
      }
      
      if let result = result {
        if result.isCancelled {
          print("cancelled")
        } else {
          print("loggend in!")
          let token = result.token
          
          Spinner.show("Идет авторизация")
          self.loginProvider.request(.Facebook(token: token.tokenString)) { (result) in
            Spinner.hide()
            switch result {
            case .Success(let response):
              do {
                let userResponse = try response.filterSuccessfulStatusCodes()
                let json = try JSON(userResponse.mapJSON())
                if let apiToken = json["api_token"].string {
                  UserManager.apiToken = apiToken
                  print("api_token: \(apiToken)")
                }
                let user = try userResponse.mapObject(User.self)
                print("User: \(user)")
                UserManager.currentUser = user
                registerForPushNotifications()
                
                self.performSegueWithIdentifier("home", sender: self)
              } catch {
                self.presentAlertWithMessage("Server response code: \(response.statusCode)")
              }
            case .Failure(let error):
              print(error)
              self.presentAlertWithMessage("Ошибка! Попробуйте позже!")
            }
          }
        }
      }
    }
  }
  
  @IBAction func vkButtonAction(sender: AnyObject) {
    Spinner.show("Идет авторизация")
    let VKAppId = NSBundle.mainBundle().objectForInfoDictionaryKey("VKAppID") as! String
    let vk = VKSdk.initializeWithAppId(VKAppId)
    vk.registerDelegate(self)
    VKSdk.authorize([], withOptions: VKAuthorizationOptions.UnlimitedToken)
  }
  
  @IBAction func phoneButtonAction(sender: AnyObject) {
    print("phone")
  }
}

extension LoginViewController: VKSdkDelegate {
  
  func vkSdkAccessAuthorizationFinishedWithResult(result: VKAuthorizationResult!) {
    if let error = result.error {
      print(error)
      Spinner.hide()
      presentAlertWithMessage("Не удалось авторизироваться чере VK")
    }
    
    if let token = result.token.accessToken {
      loginProvider.request(.VK(token: token)) { result in
        Spinner.hide()
        switch result {
        case .Success(let response):
          do {
            let userResponse = try response.filterSuccessfulStatusCodes()
            let json = try JSON(userResponse.mapJSON())
            if let apiToken = json["api_token"].string {
              UserManager.apiToken = apiToken
              print("api_token: \(apiToken)")
            }
            let user = try userResponse.mapObject(User.self)
            print("User: \(user)")
            UserManager.currentUser = user
            registerForPushNotifications()
            self.performSegueWithIdentifier("home", sender: self)
          } catch {
            self.presentAlertWithMessage("Не удалось авторизироваться чере VK")
          }
        case .Failure(let error):
          print(error)
          self.presentAlertWithMessage("Не удалось авторизироваться чере VK")
        }
      }
    }
  }
  
  func vkSdkUserAuthorizationFailed() {
    Spinner.hide()
    presentAlertWithMessage("Не удалось авторизироваться чере VK")
  }
}
