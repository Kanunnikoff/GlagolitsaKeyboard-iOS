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

    var isAutocapitalizationEnabled = true

    override func shouldTriggerFeedback(
        for gesture: Keyboard.Gesture,
        on action: KeyboardAction
    ) -> Bool {
        guard isKeyboardAudioFeedback else {
            return false
        }

        return super.shouldTriggerFeedback(for: gesture, on: action)
    }

    override func preferredKeyboardCase(
        after gesture: Keyboard.Gesture,
        on action: KeyboardAction
    ) -> Keyboard.KeyboardCase {
        if action.isShiftAction {
            // Отключение автоматических заглавных букв не должно запрещать ручной
            // выбор регистра. К этому моменту библиотека уже обработала Shift,
            // поэтому сохраняем результат стандартного поведения.
            return super.preferredKeyboardCase(after: gesture, on: action)
        }

        if keyboardContext.keyboardCase == .capsLocked {
            // Двойное нажатие на Shift явно включает постоянный верхний регистр.
            // Автоматический пересчёт после ввода не должен отменять этот выбор.
            return .capsLocked
        }

        // После пробела, удаления и знаков препинания библиотека заново вычисляет
        // регистр. При выключенной настройке не даём ей автоматически включить Shift.
        guard isAutocapitalizationEnabled else {
            return .lowercased
        }

        return super.preferredKeyboardCase(after: gesture, on: action)
    }
}
