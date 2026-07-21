//
//  MyKeyboardAppearance.swift
//  Keyboard
//
//  Created by Дмитрiй Канунниковъ on 09.07.2022.
//

import Foundation
import KeyboardKit
import SwiftUI
import UIKit

enum MyKeyboardAppearance {

    static func buttonTitle(
        for action: KeyboardAction,
        language: KeyboardLanguage
    ) -> String? {
        let modernTitle: String

        switch action {
            case .space:
                modernTitle = localizedButtonTitle(
                    forKey: KeyboardButtonLocalizationKey.space,
                    language: language
                )

            case .primary:
                modernTitle = localizedButtonTitle(
                    forKey: KeyboardButtonLocalizationKey.enter,
                    language: language
                )

            default:
                return nil
        }

        return language.glagoliticText(for: modernTitle)
    }

    private static func localizedButtonTitle(
        forKey key: String,
        language: KeyboardLanguage
    ) -> String {
        // Язык раскладки пользователь выбирает независимо от языка приложения.
        // Загружаем его каталог явно, иначе Bundle.main вернёт перевод интерфейса.
        guard let localizationPath = Bundle.main.path(
            forResource: language.rawValue,
            ofType: "lproj"
        ), let localizationBundle = Bundle(path: localizationPath) else {
            return key
        }

        return localizationBundle.localizedString(
            forKey: key,
            value: key,
            table: nil
        )
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
        let customFont = Font.custom(GlagoliticFont.roundedPostScriptName, size: size)
        if let weight {
            style.nativeFont = customFont.weight(weight.fontWeight)
        } else {
            style.nativeFont = customFont
        }

        style.keyboardFont = nil

        return style
    }

    static func calloutStyle(usesSystemFont: Bool) -> KeyboardCalloutStyle {
        var style = KeyboardCalloutStyle.standard
        guard !usesSystemFont else {
            return style
        }

        // KeyboardKit оформляет всплывающую подсказку отдельно от клавиши,
        // поэтому стиль основной кнопки на варианты долгого удержания не влияет.
        // Заменяем только семейство шрифта, сохраняя штатные размеры и насыщенность.
        style.actionItemFont = roundedFont(basedOn: style.actionItemFont)
        style.inputItemFont = roundedFont(basedOn: style.inputItemFont)

        return style
    }

    private static func roundedFont(basedOn font: KeyboardFont) -> KeyboardFont {
        KeyboardFont(
            .custom(
                GlagoliticFont.roundedPostScriptName,
                size: font.type.pointSize
            ),
            font.weight
        )
    }
}

private enum KeyboardButtonLocalizationKey {

    static let enter = "Enter"
    static let space = "Space"
}

private extension KeyboardFont.FontType {

    var pointSize: CGFloat {
        switch self {
            case .custom(_, let size),
                 .customFixed(_, let size),
                 .system(let size):
                return size

            case .largeTitle:
                return UIFont.preferredFont(forTextStyle: .largeTitle).pointSize

            case .title:
                return UIFont.preferredFont(forTextStyle: .title1).pointSize

            case .title2:
                return UIFont.preferredFont(forTextStyle: .title2).pointSize

            case .title3:
                return UIFont.preferredFont(forTextStyle: .title3).pointSize

            case .headline:
                return UIFont.preferredFont(forTextStyle: .headline).pointSize

            case .subheadline:
                return UIFont.preferredFont(forTextStyle: .subheadline).pointSize

            case .body:
                return UIFont.preferredFont(forTextStyle: .body).pointSize

            case .callout:
                return UIFont.preferredFont(forTextStyle: .callout).pointSize

            case .footnote:
                return UIFont.preferredFont(forTextStyle: .footnote).pointSize

            case .caption:
                return UIFont.preferredFont(forTextStyle: .caption1).pointSize

            case .caption2:
                return UIFont.preferredFont(forTextStyle: .caption2).pointSize

            @unknown default:
                // Для нового семантического типа из будущей версии KeyboardKit
                // используем нейтральный системный размер вместо сбоя сборки.
                return UIFont.preferredFont(forTextStyle: .body).pointSize
        }
    }
}
