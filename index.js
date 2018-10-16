import {
  NativeModules,
  Platform,
  NativeEventEmitter,
  DeviceEventEmitter,
} from 'react-native';

const ChannelModule = NativeModules.RNChannelIO;
export const ChannelEventEmitter = Platform.select({
  ios: new NativeEventEmitter(NativeModules.RNChannelIO),
  android: DeviceEventEmitter,
});

var listeners = {};

resetListeners = () => {
  Object.keys(listeners).forEach((key) => {
    listeners[key].remove();
  });

  listeners = {};
}

replaceListener = (type, newSubscriber) => {
  let subscriber = listeners[type];
  if (subscriber != undefined) {
    subscriber.remove();
  }
  listeners[type] = newSubscriber;
}

export const ChannelIO = {
  
  /**
   * Boot `ChannelIO`
   * Note that in order to use any methods from `ChannelIO`, you have to use this method beforehand 
   * @param settings ChannelPluginSettings object contains information for booting
   * @returns A promise that returns status and guest info
   */
  boot: async (settings) => {
    ChannelModule.setLinkHandle(false);
    resetListeners();

    return ChannelModule.boot(settings);
  },
  
  /**
   * Shutdown `ChannelIO`
   */
  shutdown: () => {
    ChannelModule.setLinkHandle(false);
    resetListeners();

    ChannelModule.shutdown();
  },
  
  /**
   * Initialize push token 
   * @param {String} token a push token
   */
  initPushToken: (token) => ChannelModule.initPushToken(token),
  
  /**
   * Show `ChannelIO` launcher 
   * @param {Boolean} aniamted Animate the launcher if true
   */
  show: (animated) => ChannelModule.show(animated),
  
  /**
   * Hide `ChannelIO` launcher 
   * @param {Boolean} aniamted Animate the launcher if true
   */
  hide: (animated) => ChannelModule.hide(animated),
  
  /**
   * Open `ChannelIO` messenger
   * @param {Boolean} aniamted Animate messenger if true
   */
  open: (animated) => ChannelModule.open(animated),
  
  /**
   * Close `ChannelIO` messenger
   * @param {Boolean} Animate messenger if true
   */
  close: (animated) => ChannelModule.close(animated),
  
  /**
   * Open user chat with given chat Id
   * @param {String} chatId user chat id 
   * @param {Boolean} animate Animate messenger if true
   */
  openChat: (chatId, animated) => ChannelModule.openChat(chatId, animated),
  
  /**
   * Send a event
   * @param {String} eventName event name
   * @param {Object} properties a json object contains information
   */
  track: (eventName, properties) => ChannelModule.track(eventName, properties),
  
  /**
   * Check whether a push data is for channel
   * @param {Object} userInfo userInfo part from push data
   * @returns {Boolean} true if the userInfo indicates `ChannelIO'`s push, otherwise false
   */
  isChannelPushNotification: async (userInfo) => ChannelModule.isChannelPushNotification(userInfo),
  
  /**
   * Handle `ChannelIO` push notification
   * @param {Object} userInfo userInfo part from push data
   */
  handlePushNotification: (userInfo) => ChannelModule.handlePushNotification(userInfo),
  
  /**
   * Event listener that triggers when badge count has been changed
   * @param {Function} cb a callback function that takes a integer badge count as parameter
   */
  onChangeBadge: (cb) => {
    let subscription = ChannelEventEmitter.addListener(ChannelModule.Event.ON_CHANGE_BADGE, (data) => {
      cb(data.count);
    });
    
    replaceListener(ChannelModule.Event.ON_CHANGE_BADGE, subscription);
  },

  /**
   * Event listener that triggers when in-app push has been arrived
   * @param {Function} cb a callback function that takes a object push data as parameter
   */
  onReceivePush: (cb) => {
    let subscription = ChannelEventEmitter.addListener(ChannelModule.Event.ON_RECEIVE_PUSH, (data) => {
      cb(data.push);
    });
    replaceListener(ChannelModule.Event.ON_RECEIVE_PUSH, subscription);
  },

  /**
   * Event listener that triggers when a link has been clicked by a user 
   * @param {Boolean} handle True if you want to handle a link, otherwise false
   * @param {Function} cb a callback function that takes a string link as parameter
   */
  onClickChatLink: (handle, cb) => {
    let subscription = ChannelModule.setLinkHandle(handle);
    ChannelEventEmitter.addListener(ChannelModule.Event.ON_CLICK_CHAT_LINK, (data) => {
      cb(data.link);
    });
    replaceListener(ChannelModule.Event.ON_CLICK_CHAT_LINK, subscription);
  },

  /**
   * Event listener that triggers when `ChannelIO` messenger is about to display 
   * @param {Function} cb a callback function
   */
  willShowMessenger: (cb) => {
    let subscription = ChannelEventEmitter.addListener(ChannelModule.Event.WILL_SHOW_MESSENGER, cb);
    replaceListener(ChannelModule.Event.WILL_SHOW_MESSENGER, subscription);
  },

  /**
   * Event listener that triggers when `ChannelIO` messenger is about to dismiss 
   * @param {Function} cb a callback function
   */
  willHideMessenger: (cb) => {
    let subscription = ChannelEventEmitter.addListener(ChannelModule.Event.WILL_HIDE_MESSENGER, cb);
    replaceListener(ChannelModule.Event.WILL_HIDE_MESSENGER, subscription);
  }
}