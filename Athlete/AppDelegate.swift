//
//  AppDelegate.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 26/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    Fabric.with([Crashlytics.self])
    configureRealm()
    configureNavigationBar()
    configureTabBar()
    configureTestDb()
    
    return true
  }
  
  //MARK: - Test db
  
  func configureTestDb() {
    try! dropDb()
    
    let trainer = Trainer()
    trainer.id = 1
    trainer.firstName = "Dan"
    trainer.lastName = "Shevlyuk"
    trainer.avatarURLString = "https://pbs.twimg.com/media/Cb0cYOjXIAEVP9p.jpg"
    
    let user = User()
    user.id = 1
    user.gender = .Male
    user.name = "Awesome Dude"
    
    let realm = try! Realm()
    
    var posts = [Post]()
    for i in 1...100 {
      let post = Post()
      post.id = i
      post.content = "Hello world \(i)"
      
      if i % 3 == 0 {
        post.content = "Исследование указанной связи должно опираться на тот факт, что математический горизонт прочно прекращает космический азимут. Кряж недоступно пододвигается под керн. Габбро, в первом приближении, деформирует далекий лимб. Метеорный дождь покрывает голоцен."
      }
      if i % 3 == 0 && i % 5 == 0 {
        post.imageURLString = "https://pbs.twimg.com/media/Cb2nfVhWwAAOv8t.jpg"
      }
      post.trainer = trainer
      post.commentsCount = 50
      post.likesCount = 100
      posts.append(post)
      
      for j in 1...7 {
        let comment = Comment()
        comment.id = j + i * 7
        comment.content = "kek \(j)"
        comment.author = user
        post.comments.append(comment)
      }
    }
    
    try! realm.write {
      realm.add(trainer)
      realm.add(user)
      realm.add(posts)
    }
    
    print("Total posts: \(trainer.posts.count)")
  }
  
  private func dropDb() throws {
    let realm = try Realm()
    try realm.write {
      realm.deleteAll()
    }
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
  
  func configureNavigationBar() {
//    navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Back")
//    navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Back")
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
//    UITabBar.appearance().backgroundColor = UIColor.tabBarBackgroundColor()
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

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

