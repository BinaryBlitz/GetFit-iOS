import UIKit
import PhoneNumberKit
import SwiftyJSON
import Moya

class PhoneVerificationTableViewController: UITableViewController {

  var loginProvider: APIProvider<GetFit.Login>!

  @IBOutlet weak var submitButton: ActionButton!
  @IBOutlet weak var verificationCodeTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()

    submitButton.backgroundColor = UIColor.blueAccentColor()
    submitButton.addTarget(self, action: #selector(self.submitButtonAction), for: .touchUpInside)
    submitButton.setTitle("Подтвердить", for: UIControlState())
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }

  override func viewDidAppear(_ animated: Bool) {
    verificationCodeTextField.becomeFirstResponder()
  }

  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    guard let sessionData = GetFit.Login.currentSessionData, let phoneNumber = sessionData.phoneNumber else { return nil }
    return "На номер \(PhoneNumberKit().format(phoneNumber, toType: .international)) должно прийти СМС сообщение с кодом подтверждения."
  }

  //MARK: - Actions

  func submitButtonAction() {
    guard let code = verificationCodeTextField.text, code != "" else {
      presentAlertWithMessage("Код не может быть пустым")
      return
    }

    submitButton.showActivityIndicator()
    loginProvider.request(GetFit.Login.confirmPhoneNumber(code: code)) { result in
      switch result {
      case .success(let response):

        do {
          try  _ = response.filterSuccessfulStatusCodes()
          let json = try JSON(response.mapJSON())
          if let apiToken = json["api_token"].string {
            UserManager.apiToken = apiToken
            LocalStorageHelper.save(apiToken, forKey: .apiToken)
            registerForPushNotifications()
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let initialViewController = mainStoryboard.instantiateInitialViewController() {
              self.present(initialViewController, animated: true, completion: nil)
            }
          } else {
            self.performSegue(withIdentifier: "registerNewUser", sender: nil)
          }
        } catch let error {
          print(error)
          self.handleErrorIn(response)
        }
      case .failure(let error):
        print(error)
        self.presentAlertWithTitle("Error", andMessage: "Check your internet connection")
      }

      self.submitButton.hideActivityIndicator()
    }
  }

  fileprivate func handleErrorIn(_ response: Response) {
    switch response.statusCode {
    case 403:
      presentAlertWithTitle("Error", andMessage: "Invalid verification code")
    case 500...599:
      presentAlertWithTitle("Error", andMessage: "Looks like our server was broken. Try again later.")
    default:
      presentAlertWithTitle("Error", andMessage: "Something was broken. Try again later.")
    }
  }

  //MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "registerNewUser" {
      let newUserController = segue.destination as! NewUserViewController
      newUserController.loginProvider = loginProvider
    }
  }

}
