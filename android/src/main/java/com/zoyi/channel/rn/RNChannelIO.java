package com.zoyi.channel.rn;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.Nullable;

import com.facebook.react.bridge.*;
import com.zoyi.channel.plugin.android.ChannelIO;
import com.zoyi.channel.plugin.android.global.PrefSupervisor;
import com.zoyi.channel.plugin.android.open.callback.BootCallback;
import com.zoyi.channel.plugin.android.open.callback.UserUpdateCallback;
import com.zoyi.channel.plugin.android.open.enumerate.BootStatus;
import com.zoyi.channel.plugin.android.open.listener.ChannelPluginListener;
import com.zoyi.channel.plugin.android.open.model.PopupData;
import com.zoyi.channel.plugin.android.open.model.User;
import com.zoyi.channel.plugin.android.util.IntentUtils;

import java.util.HashMap;
import java.util.Map;

import io.channel.plugin.android.open.model.Appearance;

public class RNChannelIO extends ReactContextBaseJavaModule implements ChannelPluginListener {

  private ReactContext reactContext;

  private boolean hasPushNotificationClickSubscriber = false;

  public RNChannelIO(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
    ChannelIO.setListener(this);
  }

  @Override
  public String getName() {
    return Const.MODULE_NAME;
  }

  @Override
  public Map<String, Object> getConstants() {
    Map<String, Object> constants = new HashMap<>();
    Map<String, String> eventMap = new HashMap<>();

    eventMap.put(Const.KEY_ON_BADGE_CHANGED, Const.EVENT_ON_BADGE_CHANGED);
    eventMap.put(Const.KEY_ON_POPUP_DATA_RECEIVED, Const.EVENT_ON_POPUP_DATA_RECEIVED);
    eventMap.put(Const.KEY_ON_SHOW_MESSENGER, Const.EVENT_ON_SHOW_MESSENGER);
    eventMap.put(Const.KEY_ON_HIDE_MESSENGER, Const.EVENT_ON_HIDE_MESSENGER);
    eventMap.put(Const.KEY_ON_CHAT_CREATED, Const.EVENT_ON_CHAT_CREATED);
    eventMap.put(Const.KEY_ON_FOLLOW_UP_CHANGED, Const.EVENT_ON_FOLLOW_UP_CHANGED);
    eventMap.put(Const.KEY_ON_URL_CLICKED, Const.EVENT_ON_URL_CLICKED);
    eventMap.put(Const.KEY_ON_PRE_URL_CLICKED, Const.EVENT_ON_PRE_URL_CLICKED);
    eventMap.put(Const.KEY_ON_PUSH_NOTIFICATION_CLICKED, Const.EVENT_ON_PUSH_NOTIFICATION_CLICKED);

    constants.put(Const.KEY_EVENT, eventMap);

    return constants;
  }

  @ReactMethod
  public void boot(ReadableMap config, final Promise promise) {
    ChannelIO.boot(
        ParseUtils.toBootConfig(config),
        new BootCallback() {
          @Override
          public void onComplete(BootStatus bootStatus, @Nullable User user) {
            promise.resolve(ParseUtils.getBootResult(bootStatus, user));
          }
        }
    );
  }

  @ReactMethod
  public void sleep() {
    ChannelIO.sleep();
  }

  @ReactMethod
  public void shutdown() {
    ChannelIO.shutdown();
  }

  @ReactMethod
  public void showChannelButton() {
    ChannelIO.showChannelButton();
  }

  @ReactMethod
  public void hideChannelButton() {
    ChannelIO.hideChannelButton();
  }

  @ReactMethod
  public void showMessenger() {
    ChannelIO.showMessenger(getCurrentActivity());
  }

  @ReactMethod
  public void hideMessenger() {
    ChannelIO.hideMessenger();
  }

  @ReactMethod
  public void openChat(String chatId, String message) {
    ChannelIO.openChat(getCurrentActivity(), chatId, message);
  }

  @ReactMethod
  public void track(String name, ReadableMap eventProperty) {
    ChannelIO.track(name, ParseUtils.toHashMap(eventProperty));
  }

  @ReactMethod
  public void updateUser(ReadableMap userData, final Promise promise) {
    ChannelIO.updateUser(
        ParseUtils.toUserData(userData),
        new UserUpdateCallback() {
          @Override
          public void onComplete(@Nullable Exception e, @Nullable User user) {
            promise.resolve(ParseUtils.getUserResult(e, user));
          }
        }
    );
  }

  @ReactMethod
  public void addTags(ReadableArray tags, final Promise promise) {
    ChannelIO.addTags(
        ParseUtils.toStringArray(tags),
        new UserUpdateCallback() {
          @Override
          public void onComplete(@Nullable Exception e, @Nullable User user) {
            promise.resolve(ParseUtils.getUserResult(e, user));
          }
        }
    );
  }

  @ReactMethod
  public void removeTags(ReadableArray tags, final Promise promise) {
    ChannelIO.removeTags(
        ParseUtils.toStringArray(tags),
        new UserUpdateCallback() {
          @Override
          public void onComplete(@Nullable Exception e, @Nullable User user) {
            promise.resolve(ParseUtils.getUserResult(e, user));
          }
        }
    );
  }

  @ReactMethod
  public void initPushToken(String token) {
    ChannelIO.initPushToken(token);
  }

  @ReactMethod
  public void isChannelPushNotification(ReadableMap userInfo, Promise promise) {
    if (ChannelIO.isChannelPushNotification(ParseUtils.toPushNotification(userInfo))) {
      promise.resolve(true);
    } else {
      promise.resolve(false);
    }
  }

  @ReactMethod
  public void receivePushNotification(ReadableMap userInfo, Promise promise) {
    if (reactContext != null) {
      Context context = reactContext.getApplicationContext();

      if (context != null) {
        ChannelIO.receivePushNotification(context, ParseUtils.toPushNotification(userInfo));
      }
    }

    promise.resolve(true);
  }

  @ReactMethod
  public void hasStoredPushNotification(Promise promise) {
    Activity activity = getCurrentActivity();

    if (activity != null) {
      promise.resolve(ChannelIO.hasStoredPushNotification(getCurrentActivity()));
    } else {
      promise.resolve(false);
    }
  }

  @ReactMethod
  public void openStoredPushNotification() {
    Activity activity = getCurrentActivity();

    if (activity != null) {
      ChannelIO.openStoredPushNotification(getCurrentActivity());
    }
  }

  @ReactMethod
  public void isBooted(Promise promise) {
    if (ChannelIO.isBooted()) {
      promise.resolve(true);
    } else {
      promise.resolve(false);
    }
  }

  @ReactMethod
  public void setDebugMode(boolean enable) {
    ChannelIO.setDebugMode(enable);
  }

  @Override
  public void onShowMessenger() {
    Utils.sendEvent(reactContext, Const.EVENT_ON_SHOW_MESSENGER, null);
  }

  @Override
  public void onHideMessenger() {
    Utils.sendEvent(reactContext, Const.EVENT_ON_HIDE_MESSENGER, null);
  }

  @Override
  public void onChatCreated(String chatId) {
    Utils.sendEvent(reactContext, Const.EVENT_ON_CHAT_CREATED, ParseUtils.createSingleMap(Const.KEY_EVENT_CHAT_ID, chatId));
  }

  @Override
  public void onBadgeChanged(int i) { }

  @Override
  public void onBadgeChanged(int unread, int alert) {
    Utils.sendEvent(reactContext, Const.EVENT_ON_BADGE_CHANGED, ParseUtils.toBadgeChanged(unread, alert));
  }

  @Override
  public void onFollowUpChanged(Map<String, String> data) {
    Utils.sendEvent(
        reactContext,
        Const.EVENT_ON_FOLLOW_UP_CHANGED,
        ParseUtils.toWritableStringMap(data)
    );
  }

  @Override
  public boolean onUrlClicked(String url) {
    Utils.sendEvent(reactContext, Const.EVENT_ON_PRE_URL_CLICKED, ParseUtils.createSingleMap(Const.KEY_EVENT_URL, url));
    return true;
  }

  @ReactMethod
  public void notifyPushNotificationClickSubscriberExistence(boolean hasPushNotificationClickSubscriber) {
    this.hasPushNotificationClickSubscriber = hasPushNotificationClickSubscriber;
  }

  @Override
  public boolean onPushNotificationClicked(final String chatId) {
    if (!hasPushNotificationClickSubscriber) { return false; }

    // `PrefSupervisor` is an internal class that does not provide compatibility promise between SDK versions
    //   -- avoid using it in third party libraries whenever possible as it may break at any time
    final String userId = PrefSupervisor.getLatestPushUserId(getCurrentActivity());
    if (userId == null) { return false; }

    Utils.sendEvent(
        reactContext,
        Const.EVENT_ON_PUSH_NOTIFICATION_CLICKED,
        ParseUtils.toWritableMap(new HashMap<String, Object>() {{
          put(Const.KEY_USER_ID, userId);
          put(Const.KEY_CHAT_ID, chatId);
        }})
    );
    return true; // defer push notification click handling -- the JavaScript code will call `performDefaultPushNotificationClickAction` if needed.
  }

  @Override
  public void onPopupDataReceived(PopupData popupData) {
    Utils.sendEvent(reactContext, Const.EVENT_ON_POPUP_DATA_RECEIVED, ParseUtils.popupDataToWritableMap(popupData));
  }

  @ReactMethod
  public void handleUrlClicked(@Nullable String url) {
    Activity activity = getCurrentActivity();

    if (activity != null && url != null) {
      IntentUtils.setUrl(activity, url).startActivity();
    }
  }

  @ReactMethod
  public void performDefaultPushNotificationClickAction(String userId, String chatId) {
    if (reactContext == null) { return; }
    final Context context = reactContext.getApplicationContext();

    final Intent intent = reconstructHostAppIntent(userId, chatId);
    if (intent == null) { return; }

    context.startActivity(intent);
  }

  private Intent reconstructHostAppIntent(String userId, String chatId) {
    // Channel Android SDK does not provide listeners a host app intent that the SDK prepared to
    // launch when onPushNotificationClicked() returns false. So "reconstruct" a new one to
    // emulate the default handling behavior of onPushNotificationClicked().

    if (reactContext == null) { return null; }
    Context context = reactContext.getApplicationContext();

    Intent intent = context.getPackageManager().getLaunchIntentForPackage(context.getPackageName());
    if (intent == null) { return null; }

    intent.addCategory(Intent.CATEGORY_LAUNCHER);
    // EXTRA_CHANNEL_ID is deliberately omitted because it is not used.
    intent.putExtra(Const.EXTRA_PERSON_TYPE, Const.USER);
    intent.putExtra(Const.EXTRA_PERSON_ID, userId);
    intent.putExtra(Const.EXTRA_CHAT_ID, chatId);

    return intent;
  }

  @ReactMethod
  public void setPage(@Nullable String page) {
    ChannelIO.setPage(page);
  }

  @ReactMethod
  public void resetPage() {
    ChannelIO.resetPage();
  }

  @ReactMethod
  public void setAppearance(@Nullable String appearance) {
    Appearance appearanceValue = ParseUtils.toAppearance(appearance);
    if (appearanceValue != null) {
      ChannelIO.setAppearance(appearanceValue);
    }
  }
}
