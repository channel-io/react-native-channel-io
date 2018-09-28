# [Channel io](https://www.channel.io) - Talk with your online customers and increase conversions.
[Channel](https://www.channel.io) is a conversational customer relationship management solution (CRM) for web businesses. Designed to capture potential customers before they leave your site and increase conversions, the web-based SaaS lets you see who’s on your site, what they’re looking at, how long/frequent they’re visiting and finally, drop in and give a little “hello” to online customers in real time.

[![Platform](https://img.shields.io/badge/platform-iOS-orange.svg)](https://cocoapods.org/pods/CHPlugin)
[![Languages](https://img.shields.io/badge/language-Objective--C%20%7C%20Swift-orange.svg)](https://github.com/zoyi/channel-plugin-ios)
[![CocoaPods](https://img.shields.io/cocoapods/v/CHPlugin.svg)](https://cocoapods.org/pods/CHPlugin) 
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Commercial License](https://img.shields.io/badge/license-Commercial-brightgreen.svg)](https://github.com/zoyi/channel-plugin-ios/blob/master/LICENSE)

## Prerequisite

* iOS 9 or above 

## Documentation

https://developers.channel.io/docs

## Install Channel plugin Framework from CocoaPods(iOS 9+)

Add below into your Podfile on Xcode.

```
target YOUR_PROJECT_TARGET do
  pod 'ChannelIO'
end
```


Install Channel plugin Framework through CocoaPods.

```
pod repo update
pod install
```

Now you can see Channel plugin framework by inspecting YOUR_PROJECT.xcworkspace.

## Install Channel plugin Framework from Carthage(iOS 9+)

1. Add `github "zoyi/channel-plugin-ios"` to your `Cartfile`.
2. Run `carthage update --platform iOS --no-use-binaries`.
3. Go to your Xcode project's "General" settings. Open `<YOUR_XCODE_PROJECT_DIRECTORY>/Carthage/Build/iOS` in Finder and drag `ChannelIO.framework` to the "Embedded Binaries" section in Xcode along with other dependencies. Make sure `Copy items if needed` is selected and click `Finish`.


