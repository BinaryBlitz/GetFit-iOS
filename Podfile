platform :ios, '9.0'

target 'Athlete' do 
  use_frameworks!
  # Fabric 
  pod 'Fabric'
  pod 'Crashlytics'

  # Networking
  pod 'Moya', git: 'https://github.com/Moya/Moya', branch: 'swift-3.0'
  pod "Moya-SwiftyJSONMapper", git: 'https://github.com/davidlondono/Moya-SwiftyJSONMapper', branch: 'patch-2'

  # DB
  pod 'RealmSwift'

  # UI
  pod 'UICountingLabel'
  pod 'MCSwipeTableViewCell'
  pod 'CVCalendar'
  pod 'PhoneNumberKit', git: 'https://github.com/marmelroy/PhoneNumberKit', branch: 'swift3.0'
  pod 'InnerShadowView'
  pod 'SwiftSpinner'
  pod 'XCDYouTubeKit'
  pod 'JSQMessagesViewController' 
  pod 'MWPhotoBrowser'
  pod 'SVPullToRefresh'

  # Tools
  pod 'SwiftDate', git: 'https://github.com/malcommac/SwiftDate', branch: 'feature/swift-3.0'
  pod 'PureLayout'
  pod 'HanekeSwift', git: 'https://github.com/Haneke/HanekeSwift', branch: 'feature/swift-3'
  pod 'Reusable', git: 'https://github.com/phatblat/Reusable', branch: 'ben/swift3'
  pod 'Toucan', git: 'https://github.com/kean/Toucan', branch: 'swift3'

  # Facebook SDK
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'

  # VK
  pod "VK-ios-sdk"
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['SWIFT_VERSION'] = '3.0'
  end
end

