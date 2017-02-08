//
//  ExerciseVideoTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 06/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import Reusable

class ExerciseVideoTableViewCell: UITableViewCell, NibReusable {

  @IBOutlet weak var videoTitleLabel: UILabel!
  @IBOutlet weak var videoDurtionLabel: UILabel!
  @IBOutlet weak var previewImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func confugure() {
    
  }
}
