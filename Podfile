platform :ios, '9.3'

target 'Athlete' do
  use_frameworks!
  # Fabric
  pod 'Fabric', '~> 1.6'
  pod 'Crashlytics', '~> 3.8'

  # Networking
  pod 'Moya', '~> 7.0'
  pod "Moya-SwiftyJSONMapper", '~> 1.0'

  # DB
  pod 'RealmSwift', '~> 2.3.0'

  # UI
  pod 'UICountingLabel', '~> 1.4'
  pod 'MCSwipeTableViewCell', '~> 2.1'
  pod 'CVCalendar', git: 'https://github.com/BxSMobility/CVCalendar'
  pod 'PhoneNumberKit', git: 'https://github.com/marmelroy/PhoneNumberKit', branch: 'swift2.3'
  pod 'InnerShadowView', '~> 1.0'
  pod 'SwiftSpinner', git: 'https://github.com/OMsignal/SwiftSpinner', branch: 'xcode8-swift2.3'
  pod 'XCDYouTubeKit', '~> 2.5'
  pod 'JSQMessagesViewController', '~> 7.3'
  pod 'MWPhotoBrowser', '~> 2.1'
  pod 'SVPullToRefresh', '~> 0.4'

  # Tools
  pod 'SwiftDate', git: 'https://github.com/malcommac/SwiftDate.git', branch: 'feature/swift_23'
  pod 'PureLayout', '~> 3.0'
  pod 'HanekeSwift', git: 'https://github.com/Haneke/HanekeSwift.git'
  pod 'Reusable', '~> 2.5'
  pod 'Toucan', git: 'https://github.com/gavinbunney/Toucan', branch: 'develop-swift-2.3'

  # Facebook SDK
  pod 'FBSDKCoreKit', '~> 4.16'
  pod 'FBSDKLoginKit', '~> 4.16'

  # VK
  pod 'VK-ios-sdk', '~> 1.4'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['SWIFT_VERSION'] = '2.3'
  end
end
