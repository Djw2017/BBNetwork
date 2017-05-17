

Pod::Spec.new do |s|

  s.name         = "BBNetwork"
  s.version      = "1.0.0"
  s.summary      = "BBNetwork is the base network library"

  s.description  = <<-DESC
                        BBNetwork 是基础网络库。
                   DESC

  s.homepage     = "https://github.com/Djw2017/BBNetwork"
 
  s.license      = {:type => "MIT",:file => "LICENSE"}

  s.author             = { "Dong JW" => "1971728089@qq.com" }
 
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/Djw2017/BBNetwork.git" }


  s.source_files  = "Pod/*.{h,m}"
  # ,"BBSDK/Utility/*.{h,m}","BBSDK/Categories/Foundation/*.{h,m}","BBSDK/Categories/UIKit/*.{h,m}","BBSDK/Macros/*.h"

  #s.frameworks = "UIKit"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency 'AFNetworking', '~> 3.1.0'

end
