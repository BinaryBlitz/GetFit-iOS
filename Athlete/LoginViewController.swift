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
  @IBOutlet weak var facebookButton: UIButton!
  @IBOutlet weak var vkButton: UIButton!
  @IBOutlet weak var phoneButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let overlay = UIView(frame: backgroundImageView.frame)
    overlay.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.51)
    backgroundImageView.addSubview(overlay)
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
}
