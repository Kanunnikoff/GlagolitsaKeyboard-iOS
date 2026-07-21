//
//  GlagoliticCalloutActionProvider.swift
//  Keyboard
//
//  Created by Дмитрiй Канунниковъ on 09.07.2022.
//

import Foundation
import KeyboardKit

/// Глаголические буквы и типографские знаки по долгому нажатию.
struct GlagoliticCalloutActionProvider {

    func calloutActions(for action: KeyboardAction) -> [KeyboardAction]? {
        guard case .character(let character) = action else {
            return nil
        }

        let calloutStrings = calloutActionStrings(for: character.lowercased())
        guard !calloutStrings.isEmpty else {
            return nil
        }

        // KeyboardKit передаёт сюда уже преобразованную по регистру букву.
        // Все варианты должны повторять регистр исходной клавиши.
        let strings = character.isUppercased
            ? calloutStrings.map { $0.uppercased() }
            : calloutStrings

        return strings.map { .character($0) }
    }

    private func calloutActionStrings(for character: String) -> [String] {
        switch character {
            case "0": return ["0", "°"]

            case "ⰰ": return ["ⰰ", "ⱝ", "ⱔ", "ⱕ", "ⱗ"]
            case "ⰳ": return ["ⰳ", "ⰼ"]
            case "ⰴ": return ["ⰴ", "ⰼ"]
            case "ⰵ": return ["ⰵ", "ⱑ", "ⱖ", "ⱙ"]
            case "ⰸ": return ["ⰸ", "ⰶ", "ⰷ"]
            case "ⰹ": return ["ⰹ", "ⰺⰹ"]
            case "ⰻ": return ["ⰻ", "ⰹ", "ⰺ", "ⱏ", "ⱐ", "ⱜ", "ⱛ"]
            case "ⰿ": return ["ⰿ", "ⱞ"]
            case "ⱁ": return ["ⱁ", "ⱉ"]
            case "ⱂ": return ["ⱂ", "ⱊ"]
            case "ⱃ": return ["ⱃ", "ⱃⰶ"]
            case "ⱄ": return ["ⱄ", "ⱎ", "ⱋ"]
            case "ⱆ": return ["ⱆ", "ⱓ", "ⱘ"]
            case "ⱇ": return ["ⱇ", "ⱚ"]
            case "ⱈ": return ["ⱈ", "ⰳ", "ⱒ"]
            case "ⱌ": return ["ⱌ", "ⱍ", "ⰼ"]
            case "ⱔ": return ["ⱔ", "ⱗ"]
            case "ⱏ": return ["ⱏ", "ⱜ"]
            case "ⱐ": return ["ⱐ", "ⱏ"]

            case "-": return ["-", "–", "—", "•"]
            case "/": return ["/", "\\"]
            case "₽": return ["₽", "$", "€", "£", "¥", "₩"]
            case "&": return ["&", "§"]
            case "”", "“": return ["\"", "”", "“", "„", "»", "«"]
            case ".": return [".", "…"]
            case "?": return ["?", "¿"]
            case "!": return ["!", "¡"]
            case "'", "’": return ["'", "’", "‘", "`"]

            case "%": return ["%", "‰"]
            case "=": return ["=", "≠", "≈"]

            default: return []
        }
    }
}
