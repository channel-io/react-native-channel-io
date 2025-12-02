# 0.12.2

## Update
* support android channel-io 13.1.0
* support iOS channel-io 13.0.2

# 0.12.1

## Update
* Remove unused react-native-firebase peerDependency

# 0.12.0

## Update
* support android channel-io 13.0.0
* support iOS channel-io 13.0.1

# 0.11.12

## Update
* Android - Support Gradle 8.0 and above

# 0.11.11

## Update
* support android channel-io 12.15.0
* support iOS channel-io 12.14.1

# 0.11.10

## Update
* support android channel-io 12.14.0
* support iOS channel-io 12.13.0

# 0.11.9

## Update
* support android channel-io 12.12.0

# 0.11.8

## Update
* support iOS channel-io 12.11.0

# 0.11.7

## Update
* support android channel-io 12.11.2
* support iOS channel-io 12.10.2

# 0.11.6

## Update
* support android channel-io 12.11.0
* support iOS channel-io 12.10.1

# 0.11.5

## Update
* support android channel-io 12.9.0
* support iOS channel-io 12.10.0

# 0.11.4

## Update
* support android channel-io 12.8.2

# 0.11.3

## Update
* support android channel-io 12.8.1
* support iOS channel-io 12.9.0

## Bug Fixes
* react-native 0.76.0 or higher: Fixes an issue where an error occurs when using setPage.

# 0.11.2

## Update
* support android channel-io 12.7.0
* support iOS channel-io 12.7.0
* remove deprecated functions
  * show / hide / open / close / handlePushNotification / onChangeBadge / onReceivePush / onClickChatLink / onChangeProfile / onProfileChanged / willShowMessenger / willHideMessenger

# 0.11.1

## Update
* support android channel-io 12.6.0
* support iOS channel-io 12.6.0

# 0.11.0

## Update
* support iOS channel-io 12.5.0

# 0.10.0

## Update
* Migrated to TypeScript
* support android channel-io 12.5.2
* support iOS channel-io 12.4.1

# 0.9.3

## Update
* support android channel-io 12.3.4

# 0.9.2

## Update
* support android channel-io 12.3.0

## Bug Fixes
* Android - Fixed issue #133
* Android - Fixed issue #129

# 0.9.1

## Update
* support android channel-io 12.2.0

# 0.9.0

## Update
* Updated channeltalk plugin v12
  * We introduce powerful feature to help your chat: Workflow. Workflow will completely replace support bots.
    * Removed ChannelIO.openSupportBot() in favor of new ChannelIO.openWorkflow().
  * Added new public API: ChannelIO.hidePopup()

# 0.8.3

## Update
* support android channel-io 11.6.3

# 0.8.2

## Update
* support android channel-io 11.2.2
* support openSupportBot

# 0.8.1

## Update
* support android channel-io 11.1.0
* support bootConfig - channelButtonOption - channelButtonIcon

# 0.8.0

## Update
* Updated channeltalk plugin v11
  * Supports dark mode
  * Redesigned UI / UX

# 0.7.12

## Update
* support android channel-io 10.0.9

## Bug Fixes
* Android - Fixed an error in isChannelPushNotification.

# 0.7.11

## Update
* support android channel-io 10.0.8

# 0.7.10

## Update
* Update RNChannelIO
  * changed deployment target 10 -> 11
  * changed dependency: "ChannelIOSDK", '~> 10'

## Bug Fixes
* Fixes an issue where both memberId and userId are omitted when using memberId and userId at the same time.

# 0.7.9

## Update
* Update README.md

# 0.7.8

## Bug Fixes
* Android - Fixed an issue where an error occurred during assembleRelease

# 0.7.7

## Update
* support android channel-io 10.0.7

# 0.7.6

## Bug Fixes
* Fix RN issue - https://github.com/facebook/react-native/issues/35210

# 0.7.5

## Update
* support android channel-io 10.0.6

# 0.7.4

## Update
* iOS - Fixed an issue where changed to false when unsubscribeText / unsubscribeEmail is empty

# 0.7.3

## Update
* support android channel-io 10.0.3

# 0.7.2

## Update
* support android channel-io 10.0.1

# 0.7.1
## Update
* support bootConfig - bubbleOption

# 0.7.0
## Update
* Updated channeltalk plugin v10

# 0.6.8

## Update
* support android channel-io 9.0.9

# 0.6.7

## Update
* support android channel-io 9.0.8

# 0.6.6

## Update
* support android channel-io 9.0.7

# 0.6.5

## Update
* support iOS channel-io 9.1.0

# 0.6.4

## Update
* support android channel-io 9.0.4

# 0.6.3

## Update
* support android channel-io 9.0.3

# 0.6.2
## Update
* support android channel-io 9.0.2

# 0.6.1

## Bug Fixes
* Fix `setPage` - if page is null

# 0.6.0

## Updates
* Added `setPage`, `resetPage` method

# 0.5.3

## Bug Fixes
* iOS - Fixed an issue where onBadgeChanged was not called

# 0.5.1

## Update
* Apply reaction
* Apply files security

# 0.5.0
## Updates
* Renew apis - channeltalk plugin v8.0

# 0.4.4 ~ 0.4.6
## Bug fixes
* Hotfix

# 0.4.3
## Bug fixes
* support android channel-io 7.0.7
* fix notification

# 0.4.2
## Bug fixes & support legacy
* fix language bug
* Legacy support - language / locale

# 0.4.1
## Bug fixes
* Android profile bug fixes
* Legacy support - userId

# 0.4.0
## Updates
* Updated channeltalk plugin v7.0

# 0.3.7
## Updates
* Updated ios target to 10.0 from 9.1

# 0.3.3
## Bug fixes
* Fixed android package name
* Fixed push payload parser crash when value was not string

# 0.3.2
## Bug fixes
* Fixed missing colon

# 0.3.1
## Updates
* Replaced `implemetation` to `api` in gradle

# 0.3.0
## Updates
* Added `onChangeProfile` method
* Removed support annotation for android

# 0.2.6
## Updates
* Updated `initPushToken` method to properly pass token string
* Updated delegate methods

# 0.2.5
## Bug fixes 
* Fixed typo `ON_BADGE_CHANGE` to `ON_CHANGE_BADGE`

# 0.2.3
## Bug fixes
* Fixed boolean value parser

# 0.2.2
## Bug fixes
* Fixed undefined when removing listeners

# 0.2.0
## Updates
* Applied handlePushNotification method signature

# 0.1.10
## Bug fixes
* Fixed `isChannelPushNotification` callback

# 0.1.8
## Updates
* Exposes event const
* Added `handledPush` for android push notification

# 0.1.7
## Updates
* Maintains only one listener per event
