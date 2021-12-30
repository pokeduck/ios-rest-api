source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'

target 'ios-rest-api' do
  use_frameworks!
  inhibit_all_warnings!
  
  pod 'Moya'
  pod 'Moya/RxSwift'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxSwiftExt', '~> 5'
  pod 'PromiseKit/CorePromise'
  pod 'KeychainAccess'
end

post_install do |pi|
    pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
        end
    end
end
