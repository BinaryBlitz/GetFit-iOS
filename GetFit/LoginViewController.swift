import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import VK_ios_sdk
import SwiftyJSON

class LoginViewController: UIViewController {

  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var facebookButton: LoginButton!
  @IBOutlet weak var vkButton: LoginButton!
  @IBOutlet weak var phoneButton: LoginButton!

  let loginProvider = APIProvider<GetFit.Login>()

  override func viewDidLoad() {
    super.viewDidLoad()

    backgroundImageView.image = UIImage(named: "LoginBG")
    let overlay = UIView(frame: backgroundImageView.frame)
    overlay.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.51)
    backgroundImageView.addSubview(overlay)

    facebookButton.text = "facebook".uppercased()
    vkButton.text = "vkontakte".uppercased()
    phoneButton.text = "phone".uppercased()

    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    navigationController?.isNavigationBarHidden = true
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  //MARK: - Actions

  @IBAction func facebookButtonAction(_ sender: AnyObject) {
    let fbLoginManager = FBSDKLoginManager()
    fbLoginManager.loginBehavior = FBSDKLoginBehavior.browser
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    fbLoginManager.logIn(withReadPermissions: ["public_profile"], from: self) { [weak self] (result, error) in
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      guard error == nil else {
        print(error.debugDescription)
        self?.presentAlertWithMessage("Не удалось войти через Facebook")
        return
      }

      if let result = result {
        if result.isCancelled {
          print("cancelled")
          self?.view.isUserInteractionEnabled = true
        } else {
          print("loggend in!")
          let token = result.token

          self?.loginProvider.request(.facebook(token: token?.tokenString ?? "")) { (result) in
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

                self?.performSegue(withIdentifier: "home", sender: self)
              } catch {
                self?.presentAlertWithMessage("Server response code: \(response.statusCode)")
              }
            case .failure(let error):
              print(error)
              self?.presentAlertWithMessage("Ошибка! Попробуйте позже!")
            }
            self?.view.isUserInteractionEnabled = true
          }
        }
      }
    }
  }

  @IBAction func vkButtonAction(_ sender: AnyObject) {
    view.isUserInteractionEnabled = false
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    let VKAppId = Bundle.main.object(forInfoDictionaryKey: "VKAppID") as! String
    let vk = VKSdk.initialize(withAppId: VKAppId)
    vk?.register(self)
    VKSdk.authorize([], with: VKAuthorizationOptions.unlimitedToken)
  }

  @IBAction func phoneButtonAction(_ sender: AnyObject) {
    print("phone")
  }
}

extension LoginViewController: VKSdkDelegate {

  func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    if let error = result.error {
      print(error)
      view.isUserInteractionEnabled = true
      presentAlertWithMessage("Не удалось авторизироваться чере VK")
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
