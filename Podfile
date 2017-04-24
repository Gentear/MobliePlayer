platform :ios, '8.0'
use_frameworks!
target 'MobliePlayer' do
pod 'MobileVLCKit'
pod 'Masonry'
pod 'CocoaHTTPServer'
end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'DD_LEGACY_MACROS=1']
        end
    end
end
