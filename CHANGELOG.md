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
