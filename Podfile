platform :ios, '9.3'

target 'GetFit' do
  use_frameworks!
  # Fabric
  pod 'Fabric'
  pod 'Crashlytics'

  # Networking
  pod 'Moya'
  pod 'Moya-SwiftyJSONMapper'

  # DB
  pod 'RealmSwift'

  # UI
  pod 'UICountingLabel'
  pod 'MCSwipeTableViewCell', '~> 2.1.4'
  pod 'CVCalendar'
  pod 'PhoneNumberKit'
  pod 'InnerShadowView', '~> 1.0'
  pod 'SwiftSpinner'
  pod 'XCDYouTubeKit', '~> 2.5'
  pod 'JSQMessagesViewController'
  pod 'MWPhotoBrowser', '~> 2.1'
  pod 'SVPullToRefresh', '~> 0.4'

  # Tools
  pod 'SwiftDate', '~> 4.0'
  pod 'PureLayout', '~> 3.0'
  pod 'HanekeSwift', git: 'https://github.com/Haneke/HanekeSwift', branch: 'feature/swift-3'
  pod 'Reusable', '~> 3.0.0'
  pod 'Toucan'

  # Facebook SDK
  pod 'FBSDKCoreKit', '~> 4.16'
  pod 'FBSDKLoginKit', '~> 4.16'

  # VK
  pod 'VK-ios-sdk', '~> 1.4'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['SWIFT_VERSION'] = '3.0'
  end
end
