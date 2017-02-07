platform :ios, '9.0'

target 'Athlete' do 
  use_frameworks!
  # Fabric 
  pod 'Fabric'
  pod 'Crashlytics'

  # Networking
  pod 'Moya'
  pod "Moya-SwiftyJSONMapper"

  # DB
  pod 'RealmSwift'

  # UI
  pod 'UICountingLabel'
  pod 'MCSwipeTableViewCell'
  pod 'CVCalendar', git: 'https://github.com/BxSMobility/CVCalendar'
  pod 'PhoneNumberKit', git: 'https://github.com/marmelroy/PhoneNumberKit', branch: 'swift2.3'
  pod 'InnerShadowView'
  pod 'SwiftSpinner', git: 'https://github.com/OMsignal/SwiftSpinner', branch: 'xcode8-swift2.3'
  pod 'XCDYouTubeKit'
  pod 'JSQMessagesViewController' 
  pod 'MWPhotoBrowser'
  pod 'SVPullToRefresh'

  # Tools
  pod 'SwiftDate', git: 'https://github.com/malcommac/SwiftDate.git', branch: 'feature/swift_23'
  pod 'PureLayout'
  pod 'HanekeSwift', git: 'https://github.com/Haneke/HanekeSwift', branch: 'feature/swift-2.3'
  pod 'Reusable'
  pod 'Toucan', git: 'https://github.com/gavinbunney/Toucan', branch: 'develop-swift-2.3'

  # Facebook SDK
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'

  # VK
  pod "VK-ios-sdk"
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['SWIFT_VERSION'] = '2.3'
  end
end

