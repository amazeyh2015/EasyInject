Pod::Spec.new do |spec|
  spec.name                  = "EasyInject"
  spec.version               = "1.0.0"
  spec.summary               = "EasyInject is a lightweight dependency inject framework for Objective-C."
  spec.homepage              = "https://github.com/amazeyh2015/EasyInject"
  spec.license               = "MIT"
  spec.author                = { "amazeyh2015" => "amazeyh2015@163.com" }
  spec.ios.deployment_target = "11.0"
  spec.osx.deployment_target = "11.0"
  spec.source                = { :git => "https://github.com/amazeyh2015/EasyInject.git", :tag => spec.version }
  spec.source_files          = "EasyInject/Sources/*.{h,m}"
  spec.public_header_files   = "EasyInject/Sources/*.h"
  spec.requires_arc          = true
end
