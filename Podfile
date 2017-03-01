platform :ios, '10.0'

target 'GetFit' do
  use_frameworks!
  # Fabric
  pod 'Fabric'
  pod 'Crashlytics'

  # Networking
  pod 'Moya', '~> 8.0'
  pod 'Moya-SwiftyJSONMapper', '~> 2.2'

  # DB
  pod 'RealmSwift', '~> 2.4'
  pod 'KeychainSwift', '~> 7.0'

  # UI
  pod 'SwipeCellKit', '~> 1.1'
  pod 'CVCalendar', '~> 1.4'
  pod 'PhoneNumberKit', '~> 1.2'
  pod 'XCDYouTubeKit', '~> 2.5'
  pod 'JSQMessagesViewController', '~> 7.3'
  pod 'Kingfisher', '~> 3.4'

  # Tools
  pod 'SwiftDate', '~> 4.0'
  pod 'PureLayout', '~> 3.0'
  pod 'Reusable', '~> 3.0'
  pod 'Toucan', '~> 0.6'

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
