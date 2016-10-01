//
//  ExerciseViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 31/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import Reusable
import XCDYouTubeKit
import Haneke

struct Video {
  let youtubeId: String
  var previewImageURL: NSURL?
  var title: String
  var duration: String
}

class ExerciseViewController: UIViewController {
  
  @IBOutlet weak var endExerciseButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  var exercise: ExerciseSession!

  var videos = [Video]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    tableView.registerReusableCell(ExerciseVideoTableViewCell)
    tableView.rowHeight = UITableViewAutomaticDimension
    
    endExerciseButton.backgroundColor = UIColor.blueAccentColor()
    
    navigationItem.title = exercise.name.uppercaseString
    
    ["LeMVDuIO3J0", "yN7KoXI9J0M"].forEach { (youtubeId) in
      XCDYouTubeClient.defaultClient().getVideoWithIdentifier(youtubeId) { (video, error) in
        if let xcdVideo = video {
          
          let formatter = NSDateComponentsFormatter()
          formatter.allowedUnits = [.Minute, .Second]
          formatter.zeroFormattingBehavior = .Pad
          let duration = formatter.stringFromTimeInterval(xcdVideo.duration)
          let video = Video(youtubeId: youtubeId!, previewImageURL: xcdVideo.smallThumbnailURL, title: xcdVideo.title, duration: duration!)
          self.videos.append(video)
          self.tableView.reloadData()
        }
      }
    }
  }
  
  //MARK: - Actions
  
  @IBAction func endExerciseAction(sender: AnyObject) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  func showTrainingTips(recognizer: UITapGestureRecognizer) {
    performSegueWithIdentifier("trainingTips", sender: self)
  }
}

//MARK: - UITableViewDataSource

extension ExerciseViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    }
    
    return videos.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCellWithIdentifier("infoCell") as! ExerciseInfoTableViewCell
      cell.configureWith(exercise)
      cell.showTipsButton.addTarget(self, action: #selector(showTrainingTips(_:)), forControlEvents: .TouchUpInside)
      
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(for: indexPath) as ExerciseVideoTableViewCell
      let video = videos[indexPath.row]
      cell.videoTitleLabel.text = video.title
      cell.previewImageView.hnk_setImageFromURL(video.previewImageURL!)
      cell.videoDurtionLabel.text = video.duration
      
      return cell
    default:
      return UITableViewCell()
    }
  }
}

//MARK: - UITableViewDelegate

extension ExerciseViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return 260
    }
    
    return 123
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    guard indexPath.section != 0 else { return }
    
    let video = videos[indexPath.row]
    let videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: video.youtubeId)
    presentViewController(videoPlayerViewController, animated: true, completion: nil)
  }
}
