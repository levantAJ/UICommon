source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!
inhibit_all_warnings!

platform :ios, '8.0'

target 'UICommon' do
	pod 'Utils', :git => 'https://github.com/levantAJ/Utils.git', :commit => '067557837203afa8c33fd655adcdbc4619b5cb54'
end

target 'UICommonTests' do

end

post_install do |installer_representation|
    installer_representation.project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end