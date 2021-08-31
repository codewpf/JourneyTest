# Podfile

platform :ios, '14.0'
install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false, :warn_for_unused_master_specs_repo => false

target 'JourneyTest' do
	use_frameworks!

	pod 'RxSwift', '~> 5'
	pod 'RxCocoa', '~> 5'
	pod 'NSObject+Rx'
	pod 'RxDataSources', '~> 4.0'
	pod 'Moya/RxSwift'
  
  pod 'SwiftyJSON'
	pod 'ObjectMapper'
  
	pod 'Kingfisher'
	pod 'SnapKit'
	pod 'MJRefresh'
	pod 'SVProgressHUD'
	pod 'FMDB'
  
  pod 'Then'
  pod 'WPFoundation'

	inhibit_all_warnings!

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
