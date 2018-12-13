/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {PushNotificationIOS, Button, AppState, Platform, StyleSheet, Text, View, NativeModules} from 'react-native';
import { ChannelIO } from 'react-native-channel-plugin'

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
  android:
    'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

type Props = {};
export default class App extends Component<Props> {
  doBoot() {
    let settings = {
      "userId":"tester",
      "pluginKey": "06ccfc12-a9fd-4c68-b364-5d19f81a60dd"//"06ccfc12-a9fd-4c68-b364-5d19f81a60dd"
    }

    ChannelIO.boot(settings).then((result) => {
      ChannelIO.show(false);
    });
  }

  componentDidMount() {
    this.doBoot();
    ChannelIO.onChangeBadge((count) => {
      console.log(count);
    });
    ChannelIO.onReceivePush((push) => {
      console.log(push);
    })
    ChannelIO.onClickChatLink(false, (link) => {
      console.log(link);
    })
    ChannelIO.willShowMessenger(() => {
      console.log("willShow");
    })
    ChannelIO.willHideMessenger(() => {
      console.log("willHide");
    })
    ChannelIO.willShowMessenger(() => {
      console.log("willShow2");
    })
    ChannelIO.onClickRedirectLink(false, (link) => {
      console.log('click redirect' + link);
    })

    PushNotificationIOS.requestPermissions();
    PushNotificationIOS.addEventListener('register', (token) => {
      ChannelIO.initPushToken(token);
    });

    PushNotificationIOS.addEventListener('notification', (notification) => {
      console.log(AppState.currentState);
      ChannelIO.isChannelPushNotification(notification.getData()).then((result) => {
        if (result) {
          ChannelIO.handlePushNotification(notification.getData()).then((_) => {
            notification.finish(PushNotificationIOS.FetchResult.NoData);
          })
          
        } else {
          //other push logics goes here
          notification.finish(PushNotificationIOS.FetchResult.NoData); 
        }
      })
    });
  }

  componentWillUnmount() {
    this.emitter.removeAllListeners();
  }

  render() {
    return (
      <View style={styles.container}>
        <Button title="send event" onPress={() => {
          ChannelIO.track("request_message");
        }} />
        <Button title="boot" onPress={() => {
          this.doBoot();
        }} />
        <Button title="shut down" onPress={() => {
          ChannelIO.shutdown();
        }} />
        <Button title="show" onPress={() => {
          ChannelIO.show(false);
        }} />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
