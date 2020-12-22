source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'

use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

target 'FlickrFilter' do

  pod 'RxSwift', '~> 4.0'
  pod 'RxCocoa', '~> 4.0'
  pod 'FlickrKit'

  target 'FlickrFilterTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      config.build_settings['SWIFT_VERSION'] = '4.2'
    end
  end
end
