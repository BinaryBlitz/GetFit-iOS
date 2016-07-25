import UIKit

class ChatsTableViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Chats"
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(closeButtonAction(_:)))
  }
  
  //MARK: - Actions
  
  func closeButtonAction(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}
