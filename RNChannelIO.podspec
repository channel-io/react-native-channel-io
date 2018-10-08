
Pod::Spec.new do |s|
  s.name         = "RNChannelIo"
  s.version      = "0.1.0"
  s.summary      = "RNChannelIo"
  s.description  = <<-DESC
                  RNChannelIo
                   DESC
  s.homepage     = "https://channel.io"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNChannelIO.git", :tag => "master" }
  s.source_files  = "ios/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  s.dependency "ChannelIO"
end

  
