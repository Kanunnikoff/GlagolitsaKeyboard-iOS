//
//  MyKeyboardActionHandler.swift
//  Keyboard
//
//  Created by Дмитрiй Канунниковъ on 09.07.2022.
//

import KeyboardKit
import SwiftUI

final class MyKeyboardActionHandler: StandardKeyboardActionHandler {

    @AppStorage(
        KeyboardSettingsKey.isAudioFeedback,
        store: UserDefaults(suiteName: Config.APP_GROUP_NAME)
    )
    private var isKeyboardAudioFeedback = false

    override func shouldTriggerFeedback(
        for gesture: Keyboard.Gesture,
        on action: KeyboardAction
    ) -> Bool {
        guard isKeyboardAudioFeedback else {
            return false
        }

        return super.shouldTriggerFeedback(for: gesture, on: action)
    }
}
