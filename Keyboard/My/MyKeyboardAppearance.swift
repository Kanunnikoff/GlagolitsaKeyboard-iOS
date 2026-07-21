//
//  MyKeyboardAppearance.swift
//  Keyboard
//
//  Created by Дмитрiй Канунниковъ on 09.07.2022.
//

import KeyboardKit
import SwiftUI

enum MyKeyboardAppearance {

    private static let customFontPostScriptName = "Shafarik-Regular"

    static func buttonTitle(for action: KeyboardAction) -> String? {
        switch action {
            case .space:
                return "Ⱂⱃⱁⰱⰵⰾ"

            case .primary:
                return "Ⰲⰲⱁⰴ"

            default:
                return nil
        }
    }

    static func buttonStyle(
        for parameters: Keyboard.ButtonStyleBuilderParams,
        usesSystemFont: Bool
    ) -> Keyboard.ButtonStyle {
        var style = parameters.standardStyle()
        guard !usesSystemFont else {
            return style
        }

        // Размер и насыщенность оставляем системными для конкретной клавиши,
        // заменяя только семейство шрифта. Так служебные и буквенные клавиши
        // сохраняют пропорции штатной раскладки KeyboardKit.
        let size = parameters.action.standardButtonFontSize(for: parameters.context)
        let weight = parameters.action.standardButtonFontWeight(for: parameters.context)

        // Стандартный стиль уже содержит системный шрифт, который библиотека
        // использует в первую очередь. Заменяем его непосредственно, иначе
        // пользовательский шрифт остаётся неиспользуемым запасным значением.
        let customFont = Font.custom(customFontPostScriptName, size: size)
        if let weight {
            style.nativeFont = customFont.weight(weight.fontWeight)
        } else {
            style.nativeFont = customFont
        }

        style.keyboardFont = nil

        return style
    }
}
