# Uncomment the next line to define a global platform for your project
inhibit_all_warnings!
platform :ios, '9.0'

target 'DangProject' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxRelay'
  pod 'RxGesture'
  # Pods for DangProject

  target 'DangProjectTests' do
    inherit! :search_paths
    # Pods for your unit test
    pod 'RxTest'
    pod 'RxSwift'
    pod 'RxRelay'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end
end
