//
//  LoginViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 10/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var facebookButton: LoginButton!
  @IBOutlet weak var vkButton: LoginButton!
  @IBOutlet weak var phoneButton: LoginButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    backgroundImageView.image = UIImage(named: "LoginBG")
    let overlay = UIView(frame: backgroundImageView.frame)
    overlay.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.51)
    backgroundImageView.addSubview(overlay)
    
    facebookButton.text = "facebook".uppercaseString
    vkButton.text = "vkontakte".uppercaseString
    phoneButton.text = "phone".uppercaseString
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: Selector(nilLiteral: ()))
  }
  
  override func viewWillAppear(animated: Bool) {
    navigationController?.navigationBarHidden = true
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  //MARK: - Actions
  
  @IBAction func facebookButtonAction(sender: AnyObject) {
    presentAlertWithMessage("Facebook login")
  }
  
  @IBAction func vkButtonAction(sender: AnyObject) {
    presentAlertWithMessage("VK login")
  }
  
  @IBAction func phoneButtonAction(sender: AnyObject) {
    print("phone")
  }
}
