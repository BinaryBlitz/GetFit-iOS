platform :ios, '10.0'

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
  pod 'SwipeCellKit'
  pod 'CVCalendar'
  pod 'PhoneNumberKit'
  pod 'XCDYouTubeKit', '~> 2.5'
  pod 'JSQMessagesViewController'
  pod 'Kingfisher'

  # Tools
  pod 'SwiftDate', '~> 4.0'
  pod 'PureLayout', '~> 3.0'
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
