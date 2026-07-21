//
//  GlagoliticInputSetProvider.swift
//  Keyboard
//
//  Created by Дмитрiй Канунниковъ on 09.07.2022.
//

import KeyboardKit

/// Наборы символов для глаголической раскладки.
struct GlagoliticInputSetProvider {

    let numericCurrency: String
    let symbolicCurrency: String

    init(
        numericCurrency: String = "₽",
        symbolicCurrency: String = "€"
    ) {
        self.numericCurrency = numericCurrency
        self.symbolicCurrency = symbolicCurrency
    }

    var alphabeticInputSet: KeyboardLayout.InputSet {
        KeyboardLayout.InputSet(rows: [
            .init(chars: "ⰺⱌⱆⰽⰵⱀⰳⱎⱋⰸⱈ"),
            .init(
                chars: "ⱇⱊⰲⰰⱂⱃⱁⰾⰴⰶⱏ",
                deviceVariations: [.pad: "ⱇⱊⰲⰰⱂⱃⱁⰾⰴⰶⱖ"]
            ),
            .init(
                chars: "ⱔⱍⱄⰿⰻⱅⱐⰱⱓ",
                deviceVariations: [.pad: "ⱔⱍⱄⰿⰻⱅⱐⰱⱓⱏ"]
            )
        ])
    }

    var numericInputSet: KeyboardLayout.InputSet {
        KeyboardLayout.InputSet(rows: [
            .init(chars: "1234567890", deviceVariations: [.pad: "1234567890–"]),
            .init(
                chars: "-/:;()\(numericCurrency)&@”",
                deviceVariations: [.pad: "@#№\(numericCurrency)•&*()’”"]
            ),
            .init(chars: ".,?!’", deviceVariations: [.pad: "%-−+=/;:!?"])
        ])
    }

    var symbolicInputSet: KeyboardLayout.InputSet {
        KeyboardLayout.InputSet(rows: [
            .init(chars: "[]{}#%^*+=", deviceVariations: [.pad: "1234567890–"]),
            .init(
                chars: "_\\|~<>$\(symbolicCurrency)£•",
                deviceVariations: [.pad: "$\(symbolicCurrency)£±•`^[]{}"]
            ),
            .init(chars: ".,?!’", deviceVariations: [.pad: "§|~…≠\\<>!?"])
        ])
    }
}
