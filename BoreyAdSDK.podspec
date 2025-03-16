Pod::Spec.new do |spec|

  spec.name         = "BoreyAdSDK"
  spec.version      = "1.1.2"
  spec.license      = { :type => 'MIT'}
  spec.summary      = "BoreyAdSDK"
  spec.description  = "BoreyAdSDK - 北风广告库"
  spec.author       = { "Borey" => "northwind@tsar.freeqiye.com" }
  spec.homepage     = "https://github.com/Northory/borey_ios.git"
  spec.source       = { :git => "https://github.com/Northory/borey_ios.git", :tag => spec.version }
  spec.requires_arc = true
  spec.platform      = :ios, "12.0"
  spec.static_framework = true
  spec.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 armv7 x86_64' }
  spec.ios.vendored_frameworks  = 'Products/BoreyAdSDK.framework'
  spec.source_files  = "Products/BoreyAdSDK.framework/**/*.{h,m,swift}"
  spec.public_header_files = 'Products/BoreyAdSDK.framework/Headers/BoreyAdSDK.h'
  spec.frameworks = 'UIKit', 'Foundation', 'Network', 'WebKit'
  spec.resources = "Products/BoreyAdSDK.framework/BoreyAdSDK.bundle"

end
