//
//  PhotoBrowserViewController.swift
//  GetFit
//
//  Created by Алексей on 09.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import PureLayout

class PhotoBrowserViewController: UIViewController {
  let scrollView = UIScrollView()
  let imageView = UIImageView()

  var imageURL: URL? = nil {
    didSet {
      imageView.kf.setImage(with: imageURL)
    }
  }

  var image: UIImage? {
    get {
      return imageView.image
    }
    set {
      imageView.image = newValue
    }
  }

  override func viewDidLoad() {
    view.backgroundColor = UIColor.black
    view.addSubview(scrollView)
    scrollView.autoPinEdgesToSuperviewEdges()
    scrollView.addSubview(imageView)
    imageView.autoPinEdgesToSuperviewEdges()
  }

  override func viewWillAppear(_ animated: Bool) {
    navigationController?.hidesBarsOnTap = true
  }

  override func viewDidAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    navigationController?.hidesBarsOnTap = false
    self.tabBarController?.tabBar.isHidden = false
  }

  override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    return .slide
  }

  override var prefersStatusBarHidden: Bool {
    return navigationController?.isNavigationBarHidden ?? true
  }

}
