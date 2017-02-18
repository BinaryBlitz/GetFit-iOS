import UIKit

protocol TrainingTipsDelegate {
  func didDismissViewController()
}

class TrainingTipsViewController: UIViewController {

  var delegate: TrainingTipsDelegate?
  var tips = [
    ("Know your limits", "Seriously, know your personal limits. I can't tell you how many times I've seen somebody give up too early or get hurt during training or racing because they simply had no idea what their real thresholds were. The whole idea behind training and/or competing is to push your thresholds to the limits to fulfill your potential. If you don't know what your limits are, how can you possibly know what your potential is?"),
    ("No pain, no gain", "Forget about fighting through the pain.Discomfort is your body telling you that you've stepped well out of your comfort zone. Pain is your body telling you to knock off whatever you're doing. If you're an endurance athlete, listen to it. "),
    ("The Farce of the lowcarb diet for athletes", "True, monitoring carb intake is one of the best ways to play around with your weight, I don't dispute that. I do it myself, and it can be a powerful tool for people who need to lose a significant amount of weight. But the everyman athlete has no need to go bonkers cutting out all kinds of carbs just for the sake of it, because that sort of eating behavior is not sustainable for an endurance athlete.")
  ]
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 18))
    headerView.backgroundColor = UIColor.white
    tableView.tableHeaderView = headerView
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
  }
  
  @IBAction func closeButtonAction(_ sender: AnyObject) {
    delegate?.didDismissViewController()
    dismiss(animated: true, completion: nil)
  }
}

extension TrainingTipsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tips.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "tipCell") as? TrainingTipTableViewCell else {
      return UITableViewCell()
    }
    
    cell.titleLabel.text = "\(indexPath.row + 1). \(tips[indexPath.row].0.uppercased())"
  
    cell.tipLabel.text = tips[indexPath.row].1
    
    return cell
  }
}
