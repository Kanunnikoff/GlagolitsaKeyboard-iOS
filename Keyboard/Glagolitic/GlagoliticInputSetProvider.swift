//
//  GlagoliticInputSetProvider.swift
//  Keyboard
//
//  Created by Дмитрiй Канунниковъ on 09.07.2022.
//

import KeyboardKit

/// Наборы символов для глаголической раскладки выбранного современного языка.
struct GlagoliticInputSetProvider {

    let language: KeyboardLanguage
    let numericCurrency: String
    let symbolicCurrency: String

    init(
        language: KeyboardLanguage,
        numericCurrency: String? = nil,
        symbolicCurrency: String = "€"
    ) {
        self.language = language
        self.numericCurrency = numericCurrency ?? language.primaryCurrency
        self.symbolicCurrency = symbolicCurrency
    }

    var alphabeticInputSet: KeyboardLayout.InputSet {
        KeyboardLayout.InputSet(
            rows: language.modernRows.map { row in
                .init(
                    chars: row.map { modernLetter in
                        language.glagoliticEquivalent(for: modernLetter)
                    }
                )
            }
        )
    }

    var numericInputSet: KeyboardLayout.InputSet {
        KeyboardLayout.InputSet(rows: [
            .init(
                chars: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
                deviceVariations: [.pad: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "–"]]
            ),
            .init(
                chars: ["-", "/", ":", ";", "(", ")", numericCurrency, "&", "@", "”"],
                deviceVariations: [.pad: ["@", "#", "№", numericCurrency, "•", "&", "*", "(", ")", "’", "”"]]
            ),
            .init(
                chars: [".", ",", "?", "!", "’"],
                deviceVariations: [.pad: ["%", "-", "−", "+", "=", "/", ";", ":", "!", "?"]]
            )
        ])
    }

    var symbolicInputSet: KeyboardLayout.InputSet {
        KeyboardLayout.InputSet(rows: [
            .init(
                chars: ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
                deviceVariations: [.pad: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "–"]]
            ),
            .init(
                chars: ["_", "\\", "|", "~", "<", ">", "$", symbolicCurrency, "£", "•"],
                deviceVariations: [.pad: ["$", symbolicCurrency, "£", "±", "•", "`", "^", "[", "]", "{", "}"]]
            ),
            .init(
                chars: [".", ",", "?", "!", "’"],
                deviceVariations: [.pad: ["§", "|", "~", "…", "≠", "\\", "<", ">", "!", "?"]]
            )
        ])
    }
}

extension KeyboardLanguage {

    func glagoliticText(for modernText: String) -> String {
        modernText.map { character in
            let modernLetter = String(character)
            let lowercasedLetter = modernLetter.lowercased(with: locale)
            let glagoliticLetter = glagoliticEquivalent(for: lowercasedLetter)

            // Таблица соответствий хранится в нижнем регистре. Регистр каждого
            // исходного знака переносим на весь результат, включая составные
            // соответствия наподобие македонских Љ, Њ и Џ.
            return modernLetter == lowercasedLetter
                ? glagoliticLetter
                : glagoliticLetter.uppercased(with: locale)
        }
        .joined()
    }
}

private extension KeyboardLanguage {

    var modernRows: [[String]] {
        let rows: [String]

        switch self {
            case .english:
                rows = ["qwertyuiop", "asdfghjkl", "zxcvbnm"]

            case .croatian, .czech, .slovak, .slovenian:
                rows = ["qwertzuiop", "asdfghjkl", "yxcvbnm"]

            case .russian:
                rows = ["йцукенгшщзх", "фывапролджэ", "ячсмитьбю"]

            case .ukrainian:
                rows = ["йцукенгшщзх", "фівапролджє", "ячсмитьбю"]

            case .belarusian:
                rows = ["йцукенгшўзх", "фывапролджэ", "ячсмітьбю"]

            case .bulgarian:
                rows = ["явертъуиопч", "асдфгхйклшщ", "зьцжбнмю"]

            case .macedonian:
                rows = ["љњертѕуиопш", "асдфгхјклчќ", "зџцвбнмѓж"]
        }

        return rows.map { row in
            row.map(String.init)
        }
    }

    var primaryCurrency: String {
        switch self {
            case .belarusian:
                return "Br"

            case .bulgarian:
                return "лв"

            case .croatian, .slovak, .slovenian:
                return "€"

            case .czech:
                return "Kč"

            case .english:
                return "$"

            case .macedonian:
                return "ден"

            case .russian:
                return "₽"

            case .ukrainian:
                return "₴"
        }
    }

    func glagoliticEquivalent(for modernLetter: String) -> String {
        if let languageSpecificEquivalent = languageSpecificEquivalents[modernLetter] {
            return languageSpecificEquivalent
        }

        // Общая таблица охватывает прямые латинские и кириллические соответствия.
        // Для букв без отдельного глаголического знака используется исторически
        // обоснованная последовательность, которую KeyboardKit вводит одной клавишей.
        return Self.commonEquivalents[modernLetter] ?? modernLetter
    }

    var languageSpecificEquivalents: [String: String] {
        switch self {
            case .ukrainian:
                // Современные украинские Г и Ґ различаются по звучанию. HERU даёт
                // наиболее близкое различение для Г, а GLAGOLI сохраняется для Ґ.
                return ["г": "ⱈ"]

            case .macedonian:
                return [
                    "ѓ": "ⰳⰺ",
                    "ќ": "ⰽⰺ",
                    "љ": "ⰾⱐ",
                    "њ": "ⱀⱐ",
                    "џ": "ⰴⰶ"
                ]

            default:
                return [:]
        }
    }

    static let commonEquivalents: [String: String] = [
        "а": "ⰰ", "a": "ⰰ",
        "б": "ⰱ", "b": "ⰱ",
        "в": "ⰲ", "v": "ⰲ", "w": "ⰲ",
        "г": "ⰳ", "g": "ⰳ", "ґ": "ⰳ",
        "д": "ⰴ", "d": "ⰴ",
        "е": "ⰵ", "e": "ⰵ", "э": "ⰵ",
        "ж": "ⰶ",
        "ѕ": "ⰷ",
        "з": "ⰸ", "z": "ⰸ",
        "і": "ⰹ",
        "й": "ⰺ", "ј": "ⰺ", "j": "ⰺ",
        "и": "ⰻ", "i": "ⰻ", "y": "ⰻ", "ѝ": "ⰻ",
        "к": "ⰽ", "k": "ⰽ", "q": "ⰽ",
        "л": "ⰾ", "l": "ⰾ",
        "м": "ⰿ", "m": "ⰿ",
        "н": "ⱀ", "n": "ⱀ",
        "о": "ⱁ", "o": "ⱁ",
        "п": "ⱂ", "p": "ⱂ",
        "р": "ⱃ", "r": "ⱃ",
        "с": "ⱄ", "s": "ⱄ",
        "т": "ⱅ", "t": "ⱅ",
        "у": "ⱆ", "u": "ⱆ", "ў": "ⱆ",
        "ф": "ⱇ", "f": "ⱇ",
        "х": "ⱈ", "h": "ⱈ",
        "ц": "ⱌ", "c": "ⱌ",
        "ч": "ⱍ",
        "ш": "ⱎ",
        "щ": "ⱋ",
        "ъ": "ⱏ",
        "ы": "ⱏⰹ",
        "ь": "ⱐ",
        "ю": "ⱓ",
        "я": "ⱔ",
        "ё": "ⱖ",
        "є": "ⰺⰵ",
        "ї": "ⰺⰹ",
        "x": "ⰽⱄ"
    ]
}
