import UIKit
import Fabric
import Crashlytics
import RealmSwift
import FBSDKCoreKit
import FBSDKLoginKit
import VK_ios_sdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  fileprivate lazy var usersProvider: APIProvider<GetFit.Users> = APIProvider<GetFit.Users>()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FBSDKApplicationDelegate.sharedInstance().application(application,
                                                          didFinishLaunchingWithOptions: launchOptions)
    Fabric.with([Crashlytics.self])
    configureRealm()
    configureNavigationBar()
    configureServerManager()
    configureTabBar()
    
    if !UserManager.authenticated {
      let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
      let login = loginStoryboard.instantiateInitialViewController()
      window?.rootViewController = login
    }
    
    return true
  }
  
  //MARK: - App configuration
  
  func configureRealm() {
    let realmDefaultConfig = Realm.Configuration(
    schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
              if oldSchemaVersion < 1 {}
            }
    )
    Realm.Configuration.defaultConfiguration = realmDefaultConfig
  }
  
  func configureServerManager() {
    if let apiToken: String = LocalStorageHelper.loadObjectForKey(.apiToken) {
      UserManager.apiToken = apiToken
    }
  }
  
  func configureNavigationBar() {
    UINavigationBar.appearance().backIndicatorImage = UIImage(named: "Back")
    UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "Back")
    UINavigationBar.appearance().barTintColor = UIColor.primaryYellowColor()
    UINavigationBar.appearance().isTranslucent = false
    UINavigationBar.appearance().tintColor = UIColor.blackTextColor()
    UINavigationBar.appearance().titleTextAttributes =
      [NSForegroundColorAttributeName: UIColor.blackTextColor(),
        NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20) ]
  }
  
  fileprivate func configureTabBar() {
    UITabBar.appearance().barTintColor = UIColor.tabBarBackgroundColor()
    UITabBar.appearance().barStyle = UIBarStyle.black
    UITabBar.appearance().tintColor = UIColor.white
    UITabBar.appearance().isTranslucent = false
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


  func applicationDidBecomeActive(_ application: UIApplication) {
    FBSDKAppEvents.activateApp()
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    VKSdk.processOpen(url, fromApplication: sourceApplication)
    return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                          open: url,
                                                          sourceApplication: sourceApplication,
                                                          annotation: annotation)
  }
  
  //MARK: - Push notifications
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
    var token = ""
    
    for i in 0 ..< deviceToken.count {
      token += String(format: "%02.2hhx", arguments: [tokenChars[i]])
    }
    
    LocalStorageHelper.save(token, forKey: .deviceToken)
    LocalStorageHelper.save(true, forKey: .shouldUpdateDeviceToken)
    updateDeviceTokenIfNeeded()
  }
  
  func updateDeviceTokenIfNeeded() {
    guard let shouldUpdateToken: Bool = LocalStorageHelper.loadObjectForKey(.shouldUpdateDeviceToken),
        let token: String = LocalStorageHelper.loadObjectForKey(.deviceToken) , shouldUpdateToken else {
      return
    }
    
    LocalStorageHelper.save(false, forKey: .shouldUpdateDeviceToken)
    usersProvider.request(GetFit.Users.updateDeviceToken(token: token)) { (result) in
      switch result {
      case .success(let response):
        do {
          try response.filterSuccessfulStatusCodes()
          print("Device token updated \(token)")
        } catch {
          LocalStorageHelper.save(true, forKey: .shouldUpdateDeviceToken)
        }
      case .failure(_):
        LocalStorageHelper.save(true, forKey: .shouldUpdateDeviceToken)
      }
    }
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    // develper.layOnTheFloor()
    // do {
    //    try developer.notToCry()
    // } catch {
    //    developer.cryALot()
    // }
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//    NSNotificationCenter.defaultCenter().postNotificationName(ReloadMessagesNotification, object: nil)
    NotificationCenter.default.post(.ReloadMessages)
  }
}
  
func registerForPushNotifications() {
  UIApplication.shared
    .registerUserNotificationSettings(
      UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
  )

  UIApplication.shared.registerForRemoteNotifications()
}
