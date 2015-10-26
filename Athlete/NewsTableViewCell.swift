//
//  NewsTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 26/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

  @IBOutlet weak var contentImageView: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
