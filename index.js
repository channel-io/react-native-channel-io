import {
  NativeModules,
  Platform,
  NativeEventEmitter,
  DeviceEventEmitter,
} from 'react-native';

const ChannelModule = NativeModules.RNChannelIO;
const ChannelEventEmitter = Platform.select({
  ios: new NativeEventEmitter(NativeModules.RNChannelIO),
  android: DeviceEventEmitter,
});

var subscribers = {};

const replaceSubscriber = (type, newSubscriber) => {
  let subscriber = subscribers[type];
  if (subscriber && typeof subscriber.remove === 'function') {
    subscriber.remove();
  }
  subscribers[type] = newSubscriber;
}

const hasSubscriber = (type) => {
  return !!subscribers[type]
}

ChannelEventEmitter.addListener(ChannelModule.Event.ON_PRE_URL_CLICKED, (data) => {
  if (!hasSubscriber(ChannelModule.Event.ON_URL_CLICKED)) {
    ChannelModule.handleUrlClicked(data.url);
  } else {
    const subscriber = subscribers[ChannelModule.Event.ON_URL_CLICKED];
    if (typeof subscriber === 'function') {
      subscriber(data);
    }
  }
});

export const ChannelIO = {

  /**
   * Boot `ChannelIO`
   * Note that in order to use any methods from `ChannelIO`, you have to use this method beforehand
   * @param bootConfig BootConfig object contains information for booting
   * @returns A promise that returns status and guest info
   */
  boot: async (bootConfig) => {
    return ChannelModule.boot(bootConfig);
  },

  /**
   * Sleep `ChannelIO`
   */
  sleep: () => {
    ChannelModule.sleep();
  },

  /**
   * Shutdown `ChannelIO`
   */
  shutdown: () => {
    ChannelModule.shutdown();
  },

  /**
   * @deprecated
   * Show `ChannelIO` button
   * @param {Boolean} aniamted Animate the launcher if true
   */
  show: (animated) => {
    console.log('ChannelIO', 'ChannelIO.show(animated) is deprecated. Please use ChannelIO.showChannelButton()')
    ChannelModule.showChannelButton()
  },
  /**
   * Show `ChannelIO` button
   */
  showChannelButton: () => ChannelModule.showChannelButton(),

  /**
   * @deprecated
   * Hide `ChannelIO` button
   * @param {Boolean} aniamted Animate the launcher if true
   */
  hide: (animated) => {
    console.log('ChannelIO', 'ChannelIO.hide(animated) is deprecated. Please use ChannelIO.hideChannelButton()')
    ChannelModule.hideChannelButton()
  },
  /**
   * Hide `ChannelIO` button
   */
  hideChannelButton: () => ChannelModule.hideChannelButton(),

  /**
   * @deprecated
   * Open `ChannelIO` messenger
   * @param {Boolean} aniamted Animate messenger if true
   */
  open: (animated) => {
    console.log('ChannelIO', 'ChannelIO.open(animated) is deprecated. Please use ChannelIO.showMessenger()')
    ChannelModule.showMessenger()
  },
  /**
   * Show `ChannelIO` messenger
   */
  showMessenger: () => ChannelModule.showMessenger(),

  /**
   * @deprecated
   * Close `ChannelIO` messenger
   * @param {Boolean} Animate messenger if true
   */
  close: (animated) => {
    console.log('ChannelIO', 'ChannelIO.close(animated) is deprecated. Please use ChannelIO.hideMessenger()')
    ChannelModule.hideMessenger()
  },
  /**
   * Hide `ChannelIO` messenger
   */
  hideMessenger: () => ChannelModule.hideMessenger(),

  /**
   * Open user chat with given chat id
   * @param {String} chatId user chat id
   * @param {String} payload auto fill message
   */
  openChat: (chatId, payload) => {
    if (typeof payload === 'string') {
      ChannelModule.openChat(chatId, payload);
    } else {
      if (typeof payload === 'boolean') {
        console.log('ChannelIO', 'ChannelIO.openChat(chatId, animated) is deprecated. Please use ChannelIO.openChat(chatId, message)')
      }
      ChannelModule.openChat(chatId, undefined);
    }
  },

  /**
   * Send a event
   * @param {String} eventName event name
   * @param {Object} properties a json object contains information
   */
  track: (eventName, properties) => ChannelModule.track(eventName, properties),

  /**
   * Update user
   * @param userData userData object contains user data information for updating
   * @returns A promise that returns exception or user info
   */
  updateUser: async (userData) => ChannelModule.updateUser(userData),

  /**
   * Add user tags
   * @param tags tags object contains tags information for adding
   * @returns A promise that returns exception or user data
   */
  addTags: async (tags) => ChannelModule.addTags(tags),

  /**
   * Remove user tags
   * @param tags tags object contains tags information for removing
   * @returns A promise that returns exception or user data
   */
  removeTags: async (tags) => ChannelModule.removeTags(tags),

  /**
   * Initialize push token
   * @param {String} token a push token
   */
  initPushToken: (token) => ChannelModule.initPushToken(token),

  /**
   * Check whether a push data is for channel
   * @param {Object} userInfo userInfo part from push data
   * @returns {Boolean} true if the userInfo indicates `ChannelIO'`s push, otherwise false
   */
  isChannelPushNotification: async (userInfo) => ChannelModule.isChannelPushNotification(userInfo),
  
  /**
   * @deprecated
   * Handle `ChannelIO` push notification
   * @param {Object} userInfo userInfo part from push data
   */
  handlePushNotification: async (userInfo) => {
    console.log('ChannelIO', 'ChannelIO.handlePushNotification(userInfo) is deprecated. Please use ChannelIO.receivePushNotification(userInfo)')
    ChannelModule.receivePushNotification(userInfo)
  },
  /**
   * Receive `ChannelIO` push notification
   * @param {Object} userInfo userInfo part from push data
   */
  receivePushNotification: async (userInfo) => ChannelModule.receivePushNotification(userInfo),

  /**
   * Check whether a push data has stored
   * @returns {Boolean} true if the `ChannelIO'`s push has stored, otherwise false
   */
  hasStoredPushNotification: async () => ChannelModule.hasStoredPushNotification(),
  
  /**
   * Open stored ChannelIO'` push notification
   */
  openStoredPushNotification: () => ChannelModule.openStoredPushNotification(),

  /**
   * @deprecated
   * Event listener that triggers when badge count has been changed
   * @param {Function} cb a callback function that takes a integer badge count as parameter
   */
  onChangeBadge: (cb) => {
    console.log('ChannelIO', 'ChannelIO.onChangeBadge(cb) is deprecated. Please use ChannelIO.onBadgeChanged(cb)')
    let subscription = ChannelEventEmitter.addListener(ChannelModule.Event.ON_BADGE_CHANGED, (data) => {
      cb(data.count);
    });

    replaceSubscriber(ChannelModule.Event.ON_BADGE_CHANGED, subscription);
  },
  /**
   * Event listener that triggers when badge count has been changed
   * @param {Function} cb a callback function that takes a integer badge count as parameter
   */
  onBadgeChanged: (cb) => {
    let subscription = ChannelEventEmitter.addListener(ChannelModule.Event.ON_BADGE_CHANGED, (data) => {
      cb(data.count);
    });

    replaceSubscriber(ChannelModule.Event.ON_BADGE_CHANGED, subscription);
  },

  /**
   * @deprecated
   * Event listener that triggers when in-app popup has been arrived
   * @param {Function} cb a callback function that takes a object popup data as parameter
   */
  onReceivePush: (cb) => {
    console.log('ChannelIO', 'ChannelIO.onReceivePush(cb) is deprecated. Please use ChannelIO.onPopupDataReceived(cb)')
    let subscription = ChannelEventEmitter.addListener(ChannelModule.Event.ON_POPUP_DATA_RECEIVED, (data) => {
      cb(data.popup);
    });

    replaceSubscriber(ChannelModule.Event.ON_POPUP_DATA_RECEIVED, subscription);
  },
  /**
   * Event listener that triggers when in-app popup has been arrived
   * @param {Function} cb a callback function that takes a object popup data as parameter
   */
  onPopupDataReceived: (cb) => {
    let subscription = ChannelEventEmitter.addListener(ChannelModule.Event.ON_POPUP_DATA_RECEIVED, (data) => {
      cb(data.popup);
    });

    replaceSubscriber(ChannelModule.Event.ON_POPUP_DATA_RECEIVED, subscription);
  },

  /**
   * @deprecated
   * Event listener that triggers when a link has been clicked by a user
   * @param {Boolean} handle True if you want to handle a link, otherwise false
   * @param {Function} cb a callback function that takes a string url as parameter
   */
  onClickChatLink: (handle, cb) => {
    console.log('ChannelIO', 'ChannelIO.onClickChatLink(handle, cb) is deprecated. Please use ChannelIO.onUrlClicked(cb)')
    replaceSubscriber(ChannelModule.Event.ON_URL_CLICKED, (data) => {
      if (!handle) {
        ChannelModule.handleUrlClicked(data.url);
      }
      cb(data.url);
    });
  },
  /**
   * Event listener that triggers when a url has been clicked by a user
   * @param {Function} cb a callback function that takes a string url as parameter
   */
  onUrlClicked: (cb) => {
    replaceSubscriber(ChannelModule.Event.ON_URL_CLICKED, (data) => {
      const next = () => {
        ChannelModule.handleUrlClicked(data.url);
      }
      cb(data.url, next);
    });
  },

  /**
   * @deprecated
   * Event listener that triggers when guest profile is updated
   * @param {Function} cb a callback function that takes a key, value
   */
  onChangeProfile: (cb) => {
    console.log('ChannelIO', 'ChannelIO.onChangeProfile(cb) is deprecated. Please use ChannelIO.onProfileChanged(cb)')
    let subscription = ChannelEventEmitter.addListener(ChannelModule.Event.ON_PROFILE_CHANGED, (data) => {
      cb(data.key, data.value);
    });
    replaceSubscriber(ChannelModule.Event.ON_PROFILE_CHANGED, subscription);
  },
  /**
   * Event listener that triggers when guest profile is updated
   * @param {Function} cb a callback function that takes a key, value
   */
  onProfileChanged: (cb) => {
    let subscription = ChannelEventEmitter.addListener(ChannelModule.Event.ON_PROFILE_CHANGED, (data) => {
      cb(data.key, data.value);
    });
    replaceSubscriber(ChannelModule.Event.ON_PROFILE_CHANGED, subscription);
  },

  /**
   * @deprecated
   * Event listener that triggers when `ChannelIO` messenger is about to display
   * @param {Function} cb a callback function
   */
  willShowMessenger: (cb) => {
    console.log('ChannelIO', 'ChannelIO.willShowMessenger(cb) is deprecated. Please use ChannelIO.onShowMessenger(cb)')
    let subscription = ChannelEventEmitter.addListener(ChannelModule.Event.ON_SHOW_MESSENGER, cb);
    replaceSubscriber(ChannelModule.Event.ON_SHOW_MESSENGER, subscription);
  },
  /**
   * Event listener that triggers when `ChannelIO` messenger is about to display
   * @param {Function} cb a callback function
   */
  onShowMessenger: (cb) => {
    let subscription = ChannelEventEmitter.addListener(ChannelModule.Event.ON_SHOW_MESSENGER, cb);
    replaceSubscriber(ChannelModule.Event.ON_SHOW_MESSENGER, subscription);
  },

  /**
   * @deprecated
   * Event listener that triggers when `ChannelIO` messenger is about to dismiss
   * @param {Function} cb a callback function
   */
  willHideMessenger: (cb) => {
    console.log('ChannelIO', 'ChannelIO.willHideMessenger(cb) is deprecated. Please use ChannelIO.onHideMessenger(cb)')
    let subscription = ChannelEventEmitter.addListener(ChannelModule.Event.ON_HIDE_MESSENGER, cb);
    replaceSubscriber(ChannelModule.Event.ON_HIDE_MESSENGER, subscription);
  },
  /**
   * Event listener that triggers when `ChannelIO` messenger is about to dismiss
   * @param {Function} cb a callback function
   */
  onHideMessenger: (cb) => {
    let subscription = ChannelEventEmitter.addListener(ChannelModule.Event.ON_HIDE_MESSENGER, cb);
    replaceSubscriber(ChannelModule.Event.ON_HIDE_MESSENGER, subscription);
  },

  /**
   * Event listener that triggers when a chat has been created by a user
   * @param {Function} cb a callback function that takes a string chat id as parameter
   */
  onChatCreated: (cb) => {
    let subscription = ChannelEventEmitter.addListener(ChannelModule.Event.ON_CHAT_CREATED, (data) => {
      cb(data.chatId);
    });
    replaceSubscriber(ChannelModule.Event.ON_CHAT_CREATED, subscription);
  },
}
