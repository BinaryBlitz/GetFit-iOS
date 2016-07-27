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
  
  private lazy var usersProvider = APIProvider<GetFit.Users>()

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
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
    if let apiToken: String = LocalStorageHelper.loadObjectForKey(.ApiToken) {
      UserManager.apiToken = apiToken
    }
  }
  
  func configureNavigationBar() {
    UINavigationBar.appearance().backIndicatorImage = UIImage(named: "Back")
    UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "Back")
    UINavigationBar.appearance().barTintColor = UIColor.primaryYellowColor()
    UINavigationBar.appearance().translucent = false
    UINavigationBar.appearance().tintColor = UIColor.blackTextColor()
    UINavigationBar.appearance().titleTextAttributes =
      [NSForegroundColorAttributeName: UIColor.blackTextColor(),
        NSFontAttributeName: UIFont.boldSystemFontOfSize(20) ]
  }
  
  private func configureTabBar() {
    UITabBar.appearance().barTintColor = UIColor.tabBarBackgroundColor()
    UITabBar.appearance().barStyle = UIBarStyle.Black
    UITabBar.appearance().tintColor = UIColor.whiteColor()
    UITabBar.appearance().translucent = false
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


  func applicationDidBecomeActive(application: UIApplication) {
    FBSDKAppEvents.activateApp()
  }
  
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    VKSdk.processOpenURL(url, fromApplication: sourceApplication)
    return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                          openURL: url,
                                                          sourceApplication: sourceApplication,
                                                          annotation: annotation)
  }
  
  //MARK: - Push notifications
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
    var token = ""
    
    for i in 0 ..< deviceToken.length {
      token += String(format: "%02.2hhx", arguments: [tokenChars[i]])
    }
    
    LocalStorageHelper.save(token, forKey: .DeviceToken)
    LocalStorageHelper.save(true, forKey: .ShouldUpdateDeviceToken)
    updateDeviceTokenIfNeeded()
  }
  
  func updateDeviceTokenIfNeeded() {
    guard let shouldUpdateToken: Bool = LocalStorageHelper.loadObjectForKey(.ShouldUpdateDeviceToken),
        token: String = LocalStorageHelper.loadObjectForKey(.DeviceToken) where shouldUpdateToken else {
      return
    }
    
    LocalStorageHelper.save(false, forKey: .ShouldUpdateDeviceToken)
    usersProvider.request(GetFit.Users.UpdateDeviceToken(token: token)) { (result) in
      switch result {
      case .Success(let response):
        do {
          try response.filterSuccessfulStatusCodes()
          print("Device token updated \(token)")
        } catch {
          LocalStorageHelper.save(true, forKey: .ShouldUpdateDeviceToken)
        }
      case .Failure(_):
        LocalStorageHelper.save(true, forKey: .ShouldUpdateDeviceToken)
      }
    }
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    // develper.layOnTheFloor()
    // do {
    //    try developer.notToCry()
    // } catch {
    //    developer.cryALot()
    // }
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    NSNotificationCenter.defaultCenter().postNotificationName(ReloadMessagesNotification, object: nil)
  }
}

