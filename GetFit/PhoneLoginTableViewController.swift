import UIKit
import PhoneNumberKit
import SwiftyJSON
import Moya

class PhoneLoginTableViewController: UITableViewController {

  let loginProvider = APIProvider<GetFit.Login>()

  @IBOutlet weak var phoneNumberTextField: PhoneNumberTextField!
  @IBOutlet weak var getCodeButton: ActionButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    showNavigationBar()
    setupPhoneNumberTextField()
    getCodeButton.backgroundColor = UIColor.blueAccentColor()
  }

  override func viewDidAppear(_ animated: Bool) {
    phoneNumberTextField.becomeFirstResponder()
    showNavigationBar()
  }

  fileprivate func showNavigationBar() {
    guard let navigationController = self.navigationController, navigationController.isNavigationBarHidden else { return }
    UIView.animate(withDuration: 0.15, animations: {
      self.navigationController?.isNavigationBarHidden = false
    })

  }

  fileprivate func setupPhoneNumberTextField() {
    phoneNumberTextField.defaultRegion = "RU"
  }

  // MARK: - Actions

  @IBAction func getCodeButtonAction() {
    guard let phone = phoneNumberTextField.text, phone != "" else {
      presentAlertWithMessage("Номер телефона не может быть пустым!")
      return
    }

    getCodeButton.showActivityIndicator()
    do {
      let phoneNumber = try PhoneNumberKit().parse(phone)
      GetFit.Login.currentSessionData = LoginSessionData(phoneNumber: phoneNumber)
      requestLoginCodeFor(phoneNumber: phoneNumber)
    } catch let error {
      print(error)
      getCodeButton.hideActivityIndicator()
      presentAlertWithMessage("Неправильный номер телефона")
    }
  }

  fileprivate func requestLoginCodeFor(phoneNumber: PhoneNumber) {
    loginProvider.request(GetFit.Login.phone(phone: phoneNumber)) { result in
      switch result {
      case .success(let response):
        do {
          try _ = response.filterSuccessfulStatusCodes()
          let json = try JSON(response.mapJSON())
          guard let token = json["token"].string else {
            throw MoyaError.jsonMapping(response)
          }

          GetFit.Login.currentSessionData?.verificationToken = token
          self.performSegue(withIdentifier: "verifyPhoneWithCode", sender: nil)
        } catch {
          self.presentAlertWithTitle("Error", andMessage: "Something was broken")
        }
      case .failure(let error):
        print(error)
        self.presentAlertWithTitle("Error", andMessage: "Check your internet connection")
      }
      self.getCodeButton.hideActivityIndicator()
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? PhoneVerificationTableViewController {
      destination.loginProvider = loginProvider
    }
  }
}
