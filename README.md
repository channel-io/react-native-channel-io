
# react-native-channel-plugin

## Getting started

`$ react-native install react-native-channel-plugin`

or 

`$ npm install react-native-channel-plugin --save`
`$ react-native link react-native-channel-plugin`

### Manual installation

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-channel-io` and add `RNChannelIo.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNChannelIo.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.zoyi.channel.rn.RNChannelIOPackage;` to the imports at the top of the file
  - Add `new RNChannelIOPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-channel-plugin'
  	project(':react-native-channel-plugin').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-channel-plugin/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-channel-io')
  	```

## Usage
```javascript
import { ChannelIO } from 'react-native-channel-plugin';
```

For more information, please check our developer site -> [link](https://developers.channel.io). 
