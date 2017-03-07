import UIKit

protocol TrainingTipsDelegate {
  func didDismissViewController()
}

class TrainingTipsViewController: UIViewController {

  var delegate: TrainingTipsDelegate?

  var tips: String = ""

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
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "tipCell") as? TrainingTipTableViewCell else {
      return UITableViewCell()
    }

    cell.tipLabel.text = tips
    return cell
  }
}
