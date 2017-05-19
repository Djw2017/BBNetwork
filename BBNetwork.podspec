

Pod::Spec.new do |s|

  s.name         = "BBNetwork"
  s.version      = "1.0.2"
  s.summary      = "BBNetwork is the base network library"

  s.description  = <<-DESC
                        BBNetwork 是基础网络库。
                   DESC

  s.homepage     = "https://github.com/Djw2017/BBNetwork"
 
  s.license      = {:type => "MIT",:file => "LICENSE"}

  s.author       = { "Dong JW" => "1971728089@qq.com" }
 
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/Djw2017/BBNetwork.git" }


  s.source_files  = "Pod/*.{h,m}"

  s.requires_arc = true

  s.dependency 'AFNetworking', '~> 3.1.0'

end
