//
//  ChatsTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 02/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

class ChatsTableViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Chats"
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "closeButtonAction:")
  }
  
  //MARK: - Actions
  
  func closeButtonAction(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}
