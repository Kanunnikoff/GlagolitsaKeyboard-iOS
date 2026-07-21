//
//  Config.swift
//  GlagolitsaKeyboard
//
//  Created by Дмитрiй Канунниковъ on 13.09.2022.
//

import Foundation

struct Config {

#if DEBUG
    static let isTestMode = true
#else
    static let isTestMode = false
#endif

    static let APPSTORE_APP_ID = 6444811224
    static let APPSTORE_APP_URL = URL(string: "https://itunes.apple.com/app/id\(APPSTORE_APP_ID)")!
    static let APPSTORE_APP_REVIEW_URL = URL(string: "https://itunes.apple.com/app/id\(APPSTORE_APP_ID)?action=write-review")!
    static let APPSTORE_DEVELOPER_URL = URL(string: "https://itunes.apple.com/developer/id1449411291")!
    static let APPSTORE_GLAGOLITSA_TRANSLATOR_URL = URL(string: "https://itunes.apple.com/app/id1584419808")!
    static let REQUEST_REVIEW_LAUNCHES_COUNT_THRESHOLD = 5

    static let PACKAGE_NAME = "software.kanunnikoff.GlagolitsaKeyboard"

    static let EMAIL_URL = URL(string: "mailto:dmitry.kanunnikoff@gmail.com?subject=Glagolitic%20%28iOS%29")!

    static let PRIVACY_POLICY_URL = URL(string: "https://docs.google.com/document/d/1heL7cVKneFvjEJ8HJrMSNPCxh2ZpJ_tZ-pppS7xQDrM/edit?usp=sharing")!

    static let APP_GROUP_NAME = "group.software.kanunnikoff.GlagolitsaKeyboard"
}

enum KeyboardSettingsKey {

    static let hasBeenUsed = "Keyboard.hasBeenUsed"
    static let isAutocapitalizationEnabled = "SettingsView.Keyboard.isAutocapitalizationEnabled"
    static let isAudioFeedback = "SettingsView.Keyboard.isAudioFeedback"
    static let isSystemFontAndSize = "SettingsView.Keyboard.isSystemFontAndSize"
}

enum GlagoliticFont {

    static let roundedPostScriptName = "Shafarik-Regular"
}
