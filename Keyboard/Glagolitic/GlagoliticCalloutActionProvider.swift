//
//  GlagoliticCalloutActionProvider.swift
//  keyboard
//
//  Created by Дмитрiй Канунниковъ on 09.07.2022.
//

import Foundation
import KeyboardKit

/**
 This class provides Glagolitic callout actions.
 
 You can use the class as a template when you want to create
 your own callout action provider.
 
 KeyboardKit Pro adds a provider for each ``KeyboardLocale``
 Check out the demo app to see them in action.
 */
class GlagoliticCalloutActionProvider: BaseCalloutActionProvider, LocalizedService {
    
    public let localeKey: String = KeyboardLocale.russian.id
    
    override func calloutActions(for char: String) -> [KeyboardAction] {
        let charValue = char.lowercased()
        let result = calloutActionStrings(for: charValue)
        let strings = char.isUppercased ? result.map{ $0.capitalized() } : result
        return strings.map { .character($0) }
    }
    
    private func calloutActionStrings(for char: String) -> [String] {
        switch char {
            case "0": return ["0", "°"]
                
            case "ⰰ": return ["ⰰ", "ⱝ", "ⱕ"] // а
            case "ⰳ": return ["ⰳ", "ⰼ"] // г
            case "ⰵ": return ["ⰵ", "ⱑ", "ⱖ", "ⱙ"] // е, є, ѣ, ё, э
            case "ⰸ": return ["ⰸ", "ⰷ"] // з, ѕ
            case "ⰻ": return ["ⰻ", "ⰹ", "ⰺ", "ⱛ"] // и, i, ї, й, ѵ
            case "ⰿ": return ["ⰿ", "ⱞ"] // м
            case "ⱁ": return ["ⱁ", "ⱉ"] // о, ѡ
            case "ⱆ": return ["ⱆ", "ⱘ"] // у, ѫ
            case "ⱇ": return ["ⱇ", "ⱚ"] // ф, ѳ
            case "ⱈ": return ["ⱈ", "ⱒ"] // х
            case "ⱍ": return ["ⱍ", "ⱍ"] // ч
            case "ⱔ": return ["ⱔ", "ⱗ"] // я
            case "ⱐ": return ["ⱐ"] // ь
            case "ⱏ": return ["ⱏ", "ⱜ"] // ъ
                
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
