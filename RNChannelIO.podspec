Pod::Spec.new do |s|
  s.name         = "RNChannelIO"
  s.version      = "0.2.2"
  s.summary      = "RNChannelIO"
  s.description  = "channel plugin for react native"
  s.homepage     = "https://channel.io"
  s.license      = { :type => "SDK", :file => "LICENSE" }
  s.author       = { 'Channel Corp.' => 'eng@channel.io', 'Channel Corp. iOS' => 'ios@channel.io' }
  s.platform     = :ios, "11.0"
  s.source       = { :git => "https://github.com/zoyi/react-native-channel-io.git" }
  s.source_files = "ios/**/*.{h,m}"
  s.requires_arc = true
  s.swift_version = '5.0'

  s.ios.deployment_target = '11.0'
  
  s.dependency "React"
  s.dependency "ChannelIOSDK", '~> 11.2'
end
