import UIKit
import Reusable
import XCDYouTubeKit
import Kingfisher

struct Video {
  let youtubeId: String
  var previewImageURL: URL?
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
    tableView.register(cellType: ExerciseVideoTableViewCell.self)
    tableView.rowHeight = UITableViewAutomaticDimension

    endExerciseButton.backgroundColor = UIColor.blueAccentColor()

    navigationItem.title = exercise.name.uppercased()

    ["LeMVDuIO3J0", "yN7KoXI9J0M"].forEach { (youtubeId) in
      XCDYouTubeClient.default().getVideoWithIdentifier(youtubeId) { (video, error) in
          if let xcdVideo = video {

            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.zeroFormattingBehavior = .pad
            let duration = formatter.string(from: xcdVideo.duration)
            let video = Video(youtubeId: youtubeId!, previewImageURL: xcdVideo.smallThumbnailURL, title: xcdVideo.title, duration: duration!)
            self.videos.append(video)
            self.tableView.reloadData()
          }
        }
    }
  }

  //MARK: - Actions

  @IBAction func endExerciseAction(_ sender: AnyObject) {
    _ = navigationController?.popViewController(animated: true)
  }

  func showTrainingTips(_ recognizer: UITapGestureRecognizer) {
    performSegue(withIdentifier: "trainingTips", sender: self)
  }
}

//MARK: - UITableViewDataSource

extension ExerciseViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    }

    return videos.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! ExerciseInfoTableViewCell
      cell.configureWith(exercise)
      cell.showTipsButton.addTarget(self, action: #selector(showTrainingTips(_:)), for: .touchUpInside)

      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(for: indexPath) as ExerciseVideoTableViewCell
      let video = videos[indexPath.row]
      cell.videoTitleLabel.text = video.title
      cell.previewImageView.kf.setImage(with: video.previewImageURL!)
      cell.videoDurtionLabel.text = video.duration

      return cell
    default:
      return UITableViewCell()
    }
  }
}

//MARK: - UITableViewDelegate

extension ExerciseViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return 260
    }

    return 123
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.section != 0 else { return }

    let video = videos[indexPath.row]
    let videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: video.youtubeId)
    present(videoPlayerViewController, animated: true, completion: nil)
  }
}
