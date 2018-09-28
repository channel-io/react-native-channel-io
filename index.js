import {
  NativeModules,
  Platform,
  NativeEventEmitter,
  DeviceEventEmitter,
} from 'react-native';

// const ChannelIO = {
//   show: (animated) => Channel.show(animated),
//   boot: (settings, profile) => Channel.boot(settings, profile),
//   onChangeBadge: Channel.Event.ON_CHANGE_BADGE,
//   onReceivePush: Channel.Event.ON_RECEIVE_PUSH
// };

export const ChannelIO = NativeModules.RNChannelIO;
export const ChannelEventEmitter = Platform.select({
  ios: new NativeEventEmitter(NativeModules.RNChannelEventEmitter),
  android: DeviceEventEmitter,
});
