//
//  Config.swift
//  GlagolitsaKeyboard
//
//  Created by Дмитрiй Канунниковъ on 13.09.2022.
//

import Foundation
import SwiftUI

struct Config {
    
    //--- Test
    
#if DEBUG
    static let isTestMode = true
#else
    static let isTestMode = false
#endif
    
    //--- App Store
    
    static let APPSTORE_APP_ID = 6444811224
    static let APPSTORE_APP_URL = URL(string: "https://itunes.apple.com/app/id\(APPSTORE_APP_ID)")!
    static let APPSTORE_APP_REVIEW_URL = URL(string: "https://itunes.apple.com/app/id\(APPSTORE_APP_ID)?action=write-review")!
    static let APPSTORE_DEVELOPER_URL = URL(string: "https://itunes.apple.com/developer/id1449411291")!
    static let APPSTORE_GLAGOLITSA_TRANSLATOR_URL = URL(string: "https://itunes.apple.com/app/id1584419808")!
    
    static let PACKAGE_NAME = "software.kanunnikoff.GlagolitsaKeyboard"
    
    //--- Feedback
    
    static let EMAIL_URL = URL(string: "mailto:dmitry.kanunnikoff@gmail.com?subject=Glagolitic%20%28iOS%29")!
    static let YOUTUBE_URL = URL(string: "https://www.youtube.com/c/DmitryKanunnikoff")!
    static let TWITTER_URL = URL(string: "https://twitter.com/DKanunnikoff")!
    static let INSTAGRAM_URL = URL(string: "https://www.instagram.com/dmitry.kanunnikoff")!
    
    //--- Privacy Policy
    
    static let PRIVACY_POLICY_URL = URL(string: "https://docs.google.com/document/d/1heL7cVKneFvjEJ8HJrMSNPCxh2ZpJ_tZ-pppS7xQDrM/edit?usp=sharing")!
    
    // --- Support
    
    static let PATREON = URL(string: "https://patreon.com/DmitryKanunnikoff")!
    static let BUY_ME_A_COFFEE = URL(string: "https://www.buymeacoffee.com/Kanunnikoff")!
    static let BOOSTY = URL(string: "https://boosty.to/dmitrykanunnikoff")!
    
    // ---
    
    static let APP_GROUP_NAME = "group.software.kanunnikoff.GlagolitsaKeyboard"
}
