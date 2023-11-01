
use_frameworks!

def shared_pods
  pod 'SwanKit', :path => './'
end

target 'SwanKit_iOS' do
  platform :ios, '12.0'
  shared_pods
  
  target 'SwanKit_iOSTests' do
      inherit! :search_paths
  end
end

target 'SwanKit_tvOS' do
  platform :tvos, '12.0'
  shared_pods
  
  target 'SwanKit_tvOSTests' do
    inherit! :search_paths
  end
end

target 'SwanKit_macOS' do
  platform :macos, '10.15'
  shared_pods
  
  target 'SwanKit_macOSTests' do
    inherit! :search_paths
  end
end

#target 'SwanKit_watchOS' do
#  platform :watchos, '3.0'
#  shared_pods
#end

#target 'SwanKit_watchOS_Extension' do
#  platform :watchos, '3.0'
#  shared_pods
#end



