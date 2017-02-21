import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import VK_ios_sdk
import SwiftyJSON

enum LoginError: Error {
  case invalidResponse
}

class LoginViewController: UIViewController {

  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var facebookButton: LoginButton!
  @IBOutlet weak var vkButton: LoginButton!
  @IBOutlet weak var phoneButton: LoginButton!

  let loginProvider = APIProvider<GetFit.Login>()

  private let facebookPermissions = ["public_profile"]

  override func viewDidLoad() {
    super.viewDidLoad()

    // Add overlay
    let overlay = UIView(frame: backgroundImageView.frame)
    overlay.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.5)
    backgroundImageView.addSubview(overlay)
  }

  override func viewWillAppear(_ animated: Bool) {
    navigationController?.isNavigationBarHidden = true
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  // MARK: - Actions

  @IBAction func facebookButtonAction(_ sender: AnyObject) {
    let fbLoginManager = FBSDKLoginManager()
    fbLoginManager.loginBehavior = FBSDKLoginBehavior.browser

    UIApplication.shared.isNetworkActivityIndicatorVisible = true

    fbLoginManager.logIn(withReadPermissions: facebookPermissions, from: self) { [weak self] (result, error) in

      UIApplication.shared.isNetworkActivityIndicatorVisible = false

      guard error == nil else {
        self?.presentAlertWithMessage("Не удалось войти через Facebook")
        return
      }
      guard let result = result else {
        return
      }
      guard !result.isCancelled else {
        self?.view.isUserInteractionEnabled = true
        return
      }

      self?
        .loginProvider
        .request(.facebook(token: result.token?.tokenString ?? "")) { (result) in
          switch result {
          case .success(let response):
            do {
              let userResponse = try response.filterSuccessfulStatusCodes()
              let userJSON = try JSON(userResponse.mapJSON())
              try self?.finishFacebookAuthentication(withUser: userJSON)
            } catch {
              self?.presentAlertWithMessage("Ошибка. Попробуйте позже.")
            }
          case .failure(_):
            self?.presentAlertWithMessage("Ошибка. Попробуйте позже.")
          }

          self?.view.isUserInteractionEnabled = true
      }
    }
  }

  @IBAction func vkButtonAction(_ sender: AnyObject) {
    view.isUserInteractionEnabled = false
    UIApplication.shared.isNetworkActivityIndicatorVisible = true

    let vkAppId = Bundle.main.object(forInfoDictionaryKey: "VKAppID") as! String
    let vk = VKSdk.initialize(withAppId: vkAppId)
    vk?.uiDelegate = self
    vk?.register(self)
    VKSdk.authorize([], with: VKAuthorizationOptions.unlimitedToken)
  }

  @IBAction func phoneButtonAction(_ sender: AnyObject) {
  }

  private func finishFacebookAuthentication(withUser userJSON: JSON) throws {
    guard let _ = userJSON["api_token"].string else { throw LoginError.invalidResponse }

    UserManager.currentUser = User(jsonData: userJSON)
    registerForPushNotifications()

    performSegue(withIdentifier: "home", sender: self)
  }
}

extension LoginViewController: VKSdkDelegate {

  func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    if let error = result.error {
      print(error)
      view.isUserInteractionEnabled = true
      presentAlertWithMessage("Не удалось авторизироваться чере VK")
      return
    }

    if let token = result.token.accessToken {
      loginProvider.request(.vk(token: token)) { result in
        self.view.isUserInteractionEnabled = true
        switch result {
        case .success(let response):
          do {
            let userResponse = try response.filterSuccessfulStatusCodes()
            let json = try JSON(userResponse.mapJSON())
            if let apiToken = json["api_token"].string {
              UserManager.apiToken = apiToken
              print("api_token: \(apiToken)")
            }
            let user = try userResponse.map(to: User.self)
            print("User: \(user)")
            UserManager.currentUser = user
            registerForPushNotifications()
            self.performSegue(withIdentifier: "home", sender: self)
          } catch {
            self.presentAlertWithMessage("Не удалось авторизироваться чере VK")
          }
        case .failure(let error):
          print(error)
          self.presentAlertWithMessage("Не удалось авторизироваться чере VK")
        }
      }
    }
  }

  func vkSdkUserAuthorizationFailed() {
    self.view.isUserInteractionEnabled = true
    presentAlertWithMessage("Не удалось авторизироваться чере VK")
  }
}

extension LoginViewController: VKSdkUIDelegate {
  func vkSdkShouldPresent(_ controller: UIViewController!) {
    present(controller, animated: true, completion: nil)
  }

  func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
  }
}
