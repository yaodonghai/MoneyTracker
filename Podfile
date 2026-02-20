# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'MoneyTracker' do
  use_frameworks!

  # Database
  pod 'FMDB'

  # UI
  pod 'SnapKit'
  pod 'Charts'

  # Keychain
  pod 'KeychainAccess'

  # HUD
  pod 'MBProgressHUD'

  # Keyboard (optional)
  pod 'IQKeyboardManagerSwift'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
