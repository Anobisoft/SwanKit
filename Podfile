platform :ios, '15.6'
use_frameworks!
inhibit_all_warnings!

workspace 'SwanKit'

# iOS таргеты
target 'SwanKit_iOS' do
  project 'SwanKit.xcodeproj'
end

target 'SwanKit_iOSTests' do
  project 'SwanKit.xcodeproj'
  inherit! :search_paths
end

target 'SwanKitDemo_iOS' do
  project 'SwanKit.xcodeproj'
end

# tvOS таргеты
target 'SwanKit_tvOS' do
  project 'SwanKit.xcodeproj'
end

target 'SwanKit_tvOSTests' do
  project 'SwanKit.xcodeproj'
  inherit! :search_paths
end

target 'SwanKitDemo_tvOS' do
  project 'SwanKit.xcodeproj'
end

# macOS таргеты
target 'SwanKit_macOS' do
  project 'SwanKit.xcodeproj'
end

target 'SwanKit_macOSTests' do
  project 'SwanKit.xcodeproj'
  inherit! :search_paths
end

target 'SwanKitDemo_macOS' do
  project 'SwanKit.xcodeproj'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      
      # Устанавливаем deployment target в зависимости от платформы
      if target.name.include?('OSX') || target.name.include?('macOS')
        config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '26.0.1'
      elsif target.name.include?('tvOS')
        config.build_settings['TVOS_DEPLOYMENT_TARGET'] = '15.6'
      else
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.6'
      end
    end
  end
end
