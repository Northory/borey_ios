Pod::Spec.new do |spec|

  spec.name         = "BoreyAdSDK"
  spec.version      = "0.0.1"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.summary      = "BoreyAdSDK"
  spec.description  = "BoreyAdSDK - 北风广告库"
  spec.author       = { "Borey" => "northwind@tsar.freeqiye.com" }
  spec.homepage     = "https://github.com/Northory/borey_ios.git"
  spec.source       = { :git => "https://github.com/Northory/borey_ios.git", :tag => spec.version }
  spec.requires_arc = true
  spec.platform      = :ios, "12.0"
  spec.ios.deployment_target = "17.5"
  spec.static_framework = true
  spec.ios.vendored_frameworks  = 'BoreyAdSDK.framework'
  spec.source_files  = "output/BoreyAdSDK.framework/**/*.{h,m,swift}"
  spec.public_header_files = 'output/BoreyAdSDK.framework/Headers/BoreyAdSDK.h'

end
