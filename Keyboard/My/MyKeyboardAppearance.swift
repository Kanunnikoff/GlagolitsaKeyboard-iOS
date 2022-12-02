//
//  MyKeyboardAppearance.swift
//  keyboard
//
//  Created by Дмитрiй Канунниковъ on 09.07.2022.
//

import SwiftUI
import KeyboardKit

class MyKeyboardAppearance: StandardKeyboardAppearance {
    
    @AppStorage("SettingsView.Keyboard.isSystemFontAndSize", store: UserDefaults(suiteName: Config.APP_GROUP_NAME))
    private var isKeyboardSystemFontAndSize: Bool = true
    
    // Стиль "всплывашки" при нажатии и удержании на кнопку (с показом похожих букв иных алфавитов)
    override func actionCalloutStyle() -> ActionCalloutStyle {
        var style = super.actionCalloutStyle()
//         style.callout.backgroundColor = .red
        return style
    }
    
    override func buttonImage(for action: KeyboardAction) -> Image? {
        super.buttonImage(for: action)
    }
    
    override func buttonStyle(
        for action: KeyboardAction,
        isPressed: Bool
    ) -> KeyboardButtonStyle {
            var style = super.buttonStyle(for: action, isPressed: isPressed)
//             style.cornerRadius = 10
//        style.font = Config.customFont
            return style
        }
    
    override func buttonFont(for action: KeyboardAction) -> Font {
        if isKeyboardSystemFontAndSize {
            return super.buttonFont(for: action)
        } else {
            let rawFont = Font.custom("Shafarik-Regular", size: buttonFontSize(for: action))
            guard let weight = buttonFontWeight(for: action) else { return rawFont }
            return rawFont.weight(weight)
        }
    }
    
    override func buttonText(for action: KeyboardAction) -> String? {
        switch action {
            case .space:
                return "Ⱂⱃⱁⰱⰵⰾ"
            case .return:
                return "Ⰲⰲⱁⰴ"
            default:
                return super.buttonText(for: action)
        }
    }
    
    // Стиль "всплывашки" при нажатии на кнопку
    override func inputCalloutStyle() -> InputCalloutStyle {
        var style = super.inputCalloutStyle()
        // style.callout.backgroundColor = .red
        return style
    }
}
