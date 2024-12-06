import {
  NativeModules,
  Platform,
  NativeEventEmitter,
  DeviceEventEmitter,
  EmitterSubscription,
} from 'react-native';

interface ChannelModuleType {
  Event: {
    ON_PRE_URL_CLICKED: string;
    ON_URL_CLICKED: string;
    ON_BADGE_CHANGED: string;
    ON_POPUP_DATA_RECEIVED: string;
    ON_FOLLOW_UP_CHANGED: string;
    ON_PUSH_NOTIFICATION_CLICKED: string;
    ON_SHOW_MESSENGER: string;
    ON_HIDE_MESSENGER: string;
    ON_CHAT_CREATED: string;
  };
  boot: (bootConfig: BootConfig) => Promise<BootResult>;
  sleep: () => void;
  shutdown: () => void;
  showChannelButton: () => void;
  hideChannelButton: () => void;
  showMessenger: () => void;
  hideMessenger: () => void;
  handleUrlClicked: (url: string) => void;
  openChat: (chatId: string, payload?: string) => void;
  openWorkflow: (workflowId: string) => void;
  track: (eventName: string, properties?: Record<string, any>) => void;
  updateUser: (userData: UserData) => Promise<any>;
  addTags: (tags: string[]) => Promise<any>;
  removeTags: (tags: string[]) => Promise<any>;
  isBooted: () => Promise<boolean>;
  setDebugMode: (enable: boolean) => void;
  initPushToken: (token: string) => void;
  isChannelPushNotification: (userInfo: any) => Promise<boolean>;
  receivePushNotification: (userInfo: any) => Promise<void>;
  hasStoredPushNotification: () => Promise<boolean>;
  openStoredPushNotification: () => void;
  setPage: (page: string | null, profile?: any) => void;
  resetPage: () => void;
  setAppearance: (appearance: string) => void;
  hidePopup: () => void;
  notifyPushNotificationClickSubscriberExistence: (exists: boolean) => void;
  performDefaultPushNotificationClickAction: (userId: string, chatId: string) => void;
}

interface BootConfig {
  pluginKey: string;
  memberId?: string;
  memberHash?: string;
  profile?: Record<string, any>;
  language?: 'en' | 'ko' | 'jp';
  unsubscribeEmail?: boolean;
  unsubscribeTexting?: boolean;
  trackDefaultEvent?: boolean;
  hidePopup?: boolean;
  channelButtonOption?: {
    xMargin?: number;
    yMargin?: number;
    position?: 'left' | 'right';
  };
  appearance?: 'system' | 'light' | 'dark';
}

interface BootResult {
  status: boolean;
  guest?: {
    id: string;
    [key: string]: any;
  };
}

interface UserData {
  [key: string]: any;
}

type Subscriber = EmitterSubscription | null | ((data: { url: string }) => void)

const ChannelModule = NativeModules.RNChannelIO as ChannelModuleType;
const ChannelEventEmitter = Platform.select({
  ios: new NativeEventEmitter(NativeModules.RNChannelIO),
  android: DeviceEventEmitter,
});

const subscribers: {
  [key: string]: Subscriber;
} = {}

const replaceSubscriber = (type: string, newSubscriber?: Subscriber) => {
  const oldSubscriber = subscribers[type];
  if (oldSubscriber && 'remove' in oldSubscriber && typeof oldSubscriber.remove === 'function') {
    oldSubscriber.remove();
  }
  if (newSubscriber) {
    subscribers[type] = newSubscriber;
  }
}

const hasSubscriber = (type: string) => {
  return !!subscribers[type]
}

ChannelEventEmitter?.addListener(ChannelModule.Event.ON_PRE_URL_CLICKED, (data: { url: string }) => {
  if (!hasSubscriber(ChannelModule.Event.ON_URL_CLICKED)) {
    ChannelModule.handleUrlClicked(data.url);
  } else {
    const subscriber = subscribers[ChannelModule.Event.ON_URL_CLICKED];
    if (typeof subscriber === 'function') {
      (subscriber as (data: { url: string }) => void)(data);
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
  boot: async (bootConfig: BootConfig) => {
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
  show: (animated: boolean) => {
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
  hide: (animated: boolean) => {
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
  open: (animated: boolean) => {
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
  close: (animated: boolean) => {
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
  openChat: (chatId: string, payload?: string) => {
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
   * Opens a user chat and starts the specified workflow.
   * - If a corresponded workflow with the provided workflowId is exists, it will be executed. if workflowId is invalid, an error page is displayed.
   * - If you don't pass workflowId, no action is taken.
   * @param {String} workflowId The ID of workflow to start with. An error page will be shown if such workflow does not exist.
   */
  openWorkflow: (workflowId: string) => {
    ChannelModule.openWorkflow(workflowId);
  },

  /**
   * Send a event
   * @param {String} eventName event name
   * @param {Object} properties a json object contains information
   */
  track: (eventName: string, properties?: Record<string, any>) => ChannelModule.track(eventName, properties),

  /**
   * Update user
   * @param userData userData object contains user data information for updating
   * @returns A promise that returns exception or user info
   */
  updateUser: async (userData: UserData) => {
    return ChannelModule.updateUser(userData)
  },

  /**
   * Add user tags
   * @param tags tags object contains tags information for adding
   * @returns A promise that returns exception or user data
   */
  addTags: async (tags: string[]) => {
    return ChannelModule.addTags(tags)
  },

  /**
   * Remove user tags
   * @param tags tags object contains tags information for removing
   * @returns A promise that returns exception or user data
   */
  removeTags: async (tags: string[]) => {
    return ChannelModule.removeTags(tags)
  },

  /**
   * Check is channel booted
   * @returns {Boolean} true if the channel is booted, otherwise false
   */  
  isBooted: async () => {
    return ChannelModule.isBooted()
  },

  /**
   * Set debug mode for native module
   * @param {Boolean} enable True if you want to set debug mode, otherwise false
   */  
  setDebugMode: (enable: boolean) => ChannelModule.setDebugMode(enable),

  /**
   * Initialize push token
   * @param {String} token a push token
   */
  initPushToken: (token: string) => ChannelModule.initPushToken(token),

  /**
   * Check whether a push data is for channel
   * @param {Object} userInfo userInfo part from push data
   * @returns {Boolean} true if the userInfo indicates `ChannelIO'`s push, otherwise false
   */
  isChannelPushNotification: async (userInfo: any) => ChannelModule.isChannelPushNotification(userInfo),
  
  /**
   * @deprecated
   * Handle `ChannelIO` push notification
   * @param {Object} userInfo userInfo part from push data
   */
  handlePushNotification: async (userInfo: any) => {
    console.log('ChannelIO', 'ChannelIO.handlePushNotification(userInfo) is deprecated. Please use ChannelIO.receivePushNotification(userInfo)')
    ChannelModule.receivePushNotification(userInfo)
  },
  /**
   * Receive `ChannelIO` push notification
   * @param {Object} userInfo userInfo part from push data
   */
  receivePushNotification: async (userInfo: any) => ChannelModule.receivePushNotification(userInfo),

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
   * Sets the name of the screen along with user chat profile. If track is called before setPage, the event will not reflect the page information.
   * @param {String} page This is the screen name when track is called. When calling .track(), the event's page is set to null.
   * @param {String} profile The user chat profile value.
   *     - When nil is assigned to a specific field within the profile object, only the value of that field is cleared.
   *     - The user chat profile value is applied when a user chat is created.
   */
  setPage: (page?: string, profile?: Record<string, any>) => {
    if (typeof page === "string") {
      ChannelModule.setPage(page, profile)
    } else if (page === null || page === undefined) {
      ChannelModule.setPage(null, profile)
    } else {
      console.error('ChannelIO', '"page" must be type of "string", null or undefined.')
    }
  },

  /**
   * Reset page data customized by developer.
   */
  resetPage: () => ChannelModule.resetPage(),

  /**
   * Sets the appearance of the SDK.
   * @param {String} appearance system | light | dark
   */
  setAppearance: (appearance: 'system' | 'light' | 'dark') => {
    if (typeof appearance === "string") {
      ChannelModule.setAppearance(appearance)
    } else {
      console.error('ChannelIO', '"appearance" must be type of "string". ex) "system", "light", "dark"')
    }
  },

  /**
   * Hides the Channel popup on the global screen.
   */
  hidePopup: () => ChannelModule.hidePopup(),

  /**
   * @deprecated
   * Event listener that triggers when badge count has been changed
   * @param {Function} cb a callback function that takes a integer badge count as parameter
   */
  onChangeBadge: (cb?: (unread: number, alert: number) => void) => {
    console.log('ChannelIO', 'ChannelIO.onChangeBadge(cb) is deprecated. Please use ChannelIO.onBadgeChanged(cb)')
    if (cb) {
      const subscription = ChannelEventEmitter?.addListener(ChannelModule.Event.ON_BADGE_CHANGED, (data) => {
        cb(data.unread, data.alert);
      });
      replaceSubscriber(ChannelModule.Event.ON_BADGE_CHANGED, subscription);
    } else {
      replaceSubscriber(ChannelModule.Event.ON_BADGE_CHANGED, null);
    }
    
  },
  /**
   * Event listener that triggers when badge count has been changed
   * @param {Function} cb a callback function that takes a integer badge count as parameter
   */
  onBadgeChanged: (cb?: (unread: number, alert: number) => void) => {
    if (cb) {
      const subscription = ChannelEventEmitter?.addListener(ChannelModule.Event.ON_BADGE_CHANGED, (data) => {
        cb(data.unread, data.alert);
      });
      replaceSubscriber(ChannelModule.Event.ON_BADGE_CHANGED, subscription);
    } else {
      replaceSubscriber(ChannelModule.Event.ON_BADGE_CHANGED, null);
    }
  },

  /**
   * @deprecated
   * Event listener that triggers when in-app popup has been arrived
   * @param {Function} cb a callback function that takes a object popup data as parameter
   */
  onReceivePush: (cb?: (popup: { chatId: string; message: string; name: string; avatarUrl: string; }) => void) => {
    console.log('ChannelIO', 'ChannelIO.onReceivePush(cb) is deprecated. Please use ChannelIO.onPopupDataReceived(cb)')
    if (cb) {
      const subscription = ChannelEventEmitter?.addListener(ChannelModule.Event.ON_POPUP_DATA_RECEIVED, (data) => {
        cb(data.popup);
      });
      replaceSubscriber(ChannelModule.Event.ON_POPUP_DATA_RECEIVED, subscription);
    } else {
      replaceSubscriber(ChannelModule.Event.ON_POPUP_DATA_RECEIVED, null);
    }
  },
  /**
   * Event listener that triggers when in-app popup has been arrived
   * @param {Function} cb a callback function that takes a object popup data as parameter
   */
  onPopupDataReceived: (cb?: (popup: { chatId: string; message: string; name: string; avatarUrl: string; }) => void) => {
    if (cb) {
      const subscription = ChannelEventEmitter?.addListener(ChannelModule.Event.ON_POPUP_DATA_RECEIVED, (data) => {
        cb(data.popup);
      });
      replaceSubscriber(ChannelModule.Event.ON_POPUP_DATA_RECEIVED, subscription);
    } else {
      replaceSubscriber(ChannelModule.Event.ON_POPUP_DATA_RECEIVED, null);
    }
  },

  /**
   * @deprecated
   * Event listener that triggers when a link has been clicked by a user
   * @param {Boolean} handle True if you want to handle a link, otherwise false
   * @param {Function} cb a callback function that takes a string url as parameter
   */
  onClickChatLink: (handle: boolean, cb?: (url: string) => void) => {
    console.log('ChannelIO', 'ChannelIO.onClickChatLink(handle, cb) is deprecated. Please use ChannelIO.onUrlClicked(cb)')
    if (cb) {
      replaceSubscriber(ChannelModule.Event.ON_URL_CLICKED, (data) => {
        if (!handle) {
          ChannelModule.handleUrlClicked(data.url);
        }
        cb(data.url);
      });
    } else {
      replaceSubscriber(ChannelModule.Event.ON_URL_CLICKED, null);
    }
  },
  /**
   * Event listener that triggers when a url has been clicked by a user
   * @param {Function} cb a callback function that takes a string url as parameter
   */
  onUrlClicked: (cb?: (url: string, next: () => void) => void) => {
    if (cb) {
      replaceSubscriber(ChannelModule.Event.ON_URL_CLICKED, (data) => {
        const next = () => {
          ChannelModule.handleUrlClicked(data.url);
        }
        cb(data.url, next);
      });
    } else {
      replaceSubscriber(ChannelModule.Event.ON_URL_CLICKED, null);
    }
  },

  /**
   * @deprecated
   * 'onChangeProfile' is deprecated. Please use 'onFollowUpChanged'.
   */
  onChangeProfile: (cb?: () => void) => {
    console.warn("'onChangeProfile' is deprecated. Please use 'onFollowUpChanged'.")
  },  

  /**
   * @deprecated
   * 'onProfileChanged' is deprecated. Please use 'onFollowUpChanged'.
   */
  onProfileChanged: (cb?: (data: Record<string, any>) => void) => {
    console.warn("'onProfileChanged' is deprecated. Please use 'onFollowUpChanged'.")
  },

  /**
   * Event listener that triggers when guest profile is updated
   * @param {Function} cb a callback function that takes a map
   */
  onFollowUpChanged: (cb?: (data: Record<string, any>) => void) => {
    if (cb) {
      const subscription = ChannelEventEmitter?.addListener(ChannelModule.Event.ON_FOLLOW_UP_CHANGED, (data) => {
        cb(data);
      });
      replaceSubscriber(ChannelModule.Event.ON_FOLLOW_UP_CHANGED, subscription);
    } else {
      replaceSubscriber(ChannelModule.Event.ON_FOLLOW_UP_CHANGED, null);
    }
  },

  /**
   * Event listener that triggers when user clicks a system push notification.
   * Note that the callback only works on Android. A call to this method on an iOS
   *  environment will be silently ignored.
   *
   * @param {Function} cb a callback function
   */
  onPushNotificationClicked: (cb?: (chatId: string, next: () => void) => void) => {
    if (Platform.OS !== 'android') { return }

    if (cb) {
      const subscription = ChannelEventEmitter?.addListener(ChannelModule.Event.ON_PUSH_NOTIFICATION_CLICKED, data => {
        const next = () => ChannelModule.performDefaultPushNotificationClickAction(data.userId, data.chatId);

        cb(data.chatId, next);
      });

      ChannelModule.notifyPushNotificationClickSubscriberExistence(true);
      replaceSubscriber(ChannelModule.Event.ON_PUSH_NOTIFICATION_CLICKED, subscription);
    } else {
      ChannelModule.notifyPushNotificationClickSubscriberExistence(false);
      replaceSubscriber(ChannelModule.Event.ON_PUSH_NOTIFICATION_CLICKED, null);
    }
  },

  /**
   * @deprecated
   * Event listener that triggers when `ChannelIO` messenger is about to display
   * @param {Function} cb a callback function
   */
  willShowMessenger: (cb?: () => void) => {
    console.log('ChannelIO', 'ChannelIO.willShowMessenger(cb) is deprecated. Please use ChannelIO.onShowMessenger(cb)')
    if (cb) {
      const subscription = ChannelEventEmitter?.addListener(ChannelModule.Event.ON_SHOW_MESSENGER, cb);
      replaceSubscriber(ChannelModule.Event.ON_SHOW_MESSENGER, subscription);
    } else {
      replaceSubscriber(ChannelModule.Event.ON_SHOW_MESSENGER, null);
    }
  },
  /**
   * Event listener that triggers when `ChannelIO` messenger is about to display
   * @param {Function} cb a callback function
   */
  onShowMessenger: (cb?: () => void) => {
    if (cb) {
      const subscription = ChannelEventEmitter?.addListener(ChannelModule.Event.ON_SHOW_MESSENGER, cb);
      replaceSubscriber(ChannelModule.Event.ON_SHOW_MESSENGER, subscription);
    } else {
      replaceSubscriber(ChannelModule.Event.ON_SHOW_MESSENGER, null);
    }
  },

  /**
   * @deprecated
   * Event listener that triggers when `ChannelIO` messenger is about to dismiss
   * @param {Function} cb a callback function
   */
  willHideMessenger: (cb?: () => void) => {
    console.log('ChannelIO', 'ChannelIO.willHideMessenger(cb) is deprecated. Please use ChannelIO.onHideMessenger(cb)')
    if (cb) {
      const subscription = ChannelEventEmitter?.addListener(ChannelModule.Event.ON_HIDE_MESSENGER, cb);
      replaceSubscriber(ChannelModule.Event.ON_HIDE_MESSENGER, subscription);
    } else {
      replaceSubscriber(ChannelModule.Event.ON_HIDE_MESSENGER, null);
    }
  },
  /**
   * Event listener that triggers when `ChannelIO` messenger is about to dismiss
   * @param {Function} cb a callback function
   */
  onHideMessenger: (cb?: () => void) => {
    if (cb) {
      const subscription = ChannelEventEmitter?.addListener(ChannelModule.Event.ON_HIDE_MESSENGER, cb);
      replaceSubscriber(ChannelModule.Event.ON_HIDE_MESSENGER, subscription);
    } else {
      replaceSubscriber(ChannelModule.Event.ON_HIDE_MESSENGER, null);
    }
  },

  /**
   * Event listener that triggers when a chat has been created by a user
   * @param {Function} cb a callback function that takes a string chat id as parameter
   */
  onChatCreated: (cb?: (chatId: string) => void) => {
    if (cb) {
      const subscription = ChannelEventEmitter?.addListener(ChannelModule.Event.ON_CHAT_CREATED, (data) => {
        cb(data.chatId);
      });
      replaceSubscriber(ChannelModule.Event.ON_CHAT_CREATED, subscription);
    } else {
      replaceSubscriber(ChannelModule.Event.ON_CHAT_CREATED, null);
    }
  },
}
