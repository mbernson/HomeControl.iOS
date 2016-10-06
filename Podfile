# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'HomeControl' do
    pod 'MQTTClient', '~> 0.8.5'
    pod 'Reachability'
    pod 'Alamofire', '~> 4.0.0'
    pod 'Promissum', git: 'https://github.com/tomlokhorst/Promissum.git'
    pod 'Promissum/Alamofire', git: 'https://github.com/tomlokhorst/Promissum.git'
    pod 'RxSwift', '3.0.0-beta.2'
    pod 'R.swift', '~> 3.0.0'
end

target 'HomeControlTests' do

end

target 'HomeControlUITests' do

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
