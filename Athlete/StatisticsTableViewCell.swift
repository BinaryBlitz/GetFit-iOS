//
//  StatisticsTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 07/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import Reusable

class StatisticsTableViewCell: UITableViewCell, NibReusable {

  @IBOutlet weak var caloriesView: UIView!
  @IBOutlet weak var distanceView: UIView!
  @IBOutlet weak var lengthView: UIView!
  @IBOutlet weak var trainingsView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    [caloriesView, distanceView, lengthView, trainingsView].forEach { (view) in
      view.layer.borderWidth = 3
      view.layer.cornerRadius = 55
    }
    
    caloriesView.layer.borderColor = UIColor.redColor().CGColor
    trainingsView.layer.borderColor = UIColor.blueAccentColor().CGColor
    lengthView.layer.borderColor = UIColor.primaryYellowColor().CGColor
    distanceView.layer.borderColor = UIColor.greenAccentColor().CGColor
  }
}
