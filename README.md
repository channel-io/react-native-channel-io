
# react-native-channel-io

## Getting started

`$ npm install react-native-channel-io --save`

### Mostly automatic installation

`$ react-native link react-native-channel-io`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-channel-io` and add `RNChannelIo.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNChannelIo.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNChannelIoPackage;` to the imports at the top of the file
  - Add `new RNChannelIoPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-channel-io'
  	project(':react-native-channel-io').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-channel-io/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-channel-io')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNChannelIo.sln` in `node_modules/react-native-channel-io/windows/RNChannelIo.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Channel.Io.RNChannelIo;` to the usings at the top of the file
  - Add `new RNChannelIoPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNChannelIo from 'react-native-channel-io';

// TODO: What to do with the module?
RNChannelIo;
```
  