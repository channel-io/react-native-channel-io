// Type definitions for react-native-channel-plugin:0.6.1
// Project: react-native-channel-plugin
// Definitions by: [Yeonggyun Kim] <https://github.com/CXZ7720>

export namespace ChannelIO {
    export type bootConfigType = {
        pluginKey: string
        memberID?: string
        memberHash?: string
        Profile?: {
            name?: string
            email?: string
            mobileNumber?: string
            avatarUrl?: string
        }
    }

    export type BootStatus =
        | 'SUCCESS'
        | 'NOT_INITIALIZED'
        | 'NETWORK_TIMEOUT'
        | 'NOT_AVAILABLE_VERSION'
        | 'SERVICE_UNDER_CONSTRUCTION'
        | 'REQUIRE_PAYMENT'
        | 'ACCESS_DENIED'
        | 'UNKNOWN_ERROR'

    export interface User {
        id: string
        memberId: string
        name: string
        avatarUrl: string
        alert: number // alert count
        profile: {
            name: string
            mobileNumber: string
        }
        unsubscribed: boolean
        tags: string[]
        language: string
    }

    export interface UserData {
        language?: string
        tags?: string[]
        profile?: {
            name?: string
            email?: string
            mobileNumber?: string
            avatarUrl?: string
            screenName: string
            timerScheduleId?: string
            timerBookId?: string
            timerBookIndexId?: string
            timerCurrentTitle?: string
            loginMethod?: string
            userId: string
            selectedTalk?: string
        }
        profileOnce?: {}
        unsubscribed?: boolean
    }

    interface BootCallback {
        BootStatus: BootStatus
        user: User
    }

    interface UserDataCallback {
        error?: any
        user?: User
    }

    function boot(bootConfig: bootConfigType): Promise<BootCallback>

    function sleep(): void

    function shutdown(): void

    function show(animated: boolean): void

    function showChannelButton(): void

    function hide(animated: boolean): void

    function hideChannelButton(): void

    function open(animated: boolean): void

    function showMessenger(): void

    function close(animated: boolean): void

    function hideMessenger(): void

    function openChat(chatId: string, paylood: string): void

    function track(eventName: string, properties: Record<string, any>)

    function updateUser(userData: UserData): Promise<UserData>

    function addTags(tags: string[]): Promise<UserDataCallback>

    function removeTags(tags: string[]): Promise<UserDataCallback>

    function isBooted(): Promise<boolean>

    function setDebugMode(enable: boolean): void

    function initPushToken(token: string): void

    function isChannelPushNotification(data: {
        [p: string]: any
    }): Promise<boolean> //userInfo: FirebaseMessagingTypes.remoteMessage.data
    // @DEPRECATED
    function handlePushNotification(userInfo: any): Promise<User>

    function receivePushNotification(userInfo: any): Promise<User>

    function hasStoredPushNotification(): Promise<boolean>

    function openStoredPushNotification(): void

    function setPage(page: string | undefined | null): void

    function resetPage(): void

    function onChangeBadge(cb: (data?: { count: any }) => void): void

    function onChangeBadged(cb: (data?: { count: any }) => void): void

    function onReceivePush(cb: (data?: { popup: any }) => void): void

    function onPopupDataReceived(
        cb: (data?: { popup: any }) => void
    ): void

    function onClickChatLink(
        handle: boolean,
        cb: (data?: { url: any }) => void
    ): void

    function onUrlClicked(cb: (data?: { url: any }) => void): void

    function onChangeProfile(
        cb: (data?: { key: any; value: any }) => void
    ): void

    function onProfileChanged(
        cb: (data?: { key: any; value: any }) => void
    ): void

    // @DEPRECATED
    function willShowMessenger(cb: (data?: any) => void): void

    function onShowMessenger(cb: (data?: any) => void): void

    function willHideMessenger(cb: (data?: any) => void): void

    function onHideMessenger(cb: (data?: any) => void): void

    function onChatCreated(cb: (data?: { chatId: any }) => void): void
}
