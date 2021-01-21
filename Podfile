# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'Lighthouse' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Lighthouse
pod 'Firebase/Analytics'
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'Firebase/Messaging'
pod 'Firebase/DynamicLinks'
pod 'Charts'
pod 'Kingfisher'
pod 'ALLoadingView'

end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
      end
    end
end

