import UIKit

class CreateWorkoutSessionsViewController: UIViewController {
  
  var workout: Workout!

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func closeButtonAction(sender: UIButton) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}
