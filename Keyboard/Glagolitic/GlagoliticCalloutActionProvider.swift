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

            case "ⰰ": return ["ⰰ", "ⱝ", "ⱕ"]
            case "ⰳ": return ["ⰳ", "ⰼ"]
            case "ⰵ": return ["ⰵ", "ⱑ", "ⱖ", "ⱙ"]
            case "ⰸ": return ["ⰸ", "ⰷ"]
            case "ⰻ": return ["ⰻ", "ⰹ", "ⰺ", "ⱛ"]
            case "ⰿ": return ["ⰿ", "ⱞ"]
            case "ⱁ": return ["ⱁ", "ⱉ"]
            case "ⱆ": return ["ⱆ", "ⱘ"]
            case "ⱇ": return ["ⱇ", "ⱚ"]
            case "ⱈ": return ["ⱈ", "ⱒ"]
            case "ⱔ": return ["ⱔ", "ⱗ"]
            case "ⱏ": return ["ⱏ", "ⱜ"]

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
