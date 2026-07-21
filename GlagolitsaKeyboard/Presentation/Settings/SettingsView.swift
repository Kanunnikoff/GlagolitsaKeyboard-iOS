//
//  SettingsView.swift
//  GlagolitsaKeyboard
//
//  Created by Дмитрiй Канунниковъ on 13.09.2022.
//

import SwiftUI

struct SettingsView: View {

    private enum LetterStyle: String, CaseIterable {

        case angular
        case rounded

        var title: LocalizedStringKey {
            switch self {
                case .angular:
                    return "Angular"

                case .rounded:
                    return "Rounded"
            }
        }

        var previewFont: Font {
            switch self {
                case .angular:
                    return .system(size: SettingsMetrics.previewFontSize)

                case .rounded:
                    return .custom(
                        GlagoliticFont.roundedPostScriptName,
                        size: SettingsMetrics.previewFontSize
                    )
            }
        }
    }

    private enum SettingsMetrics {

        static let letterStyleSpacing: CGFloat = 12
        static let previewFontSize: CGFloat = 34
        static let previewVerticalPadding: CGFloat = 6
    }

    private enum SettingsText {

        static let letterStylePreview = "ⰀⰁⰂⰃⰄⰅ"
    }

    @AppStorage(
        KeyboardSettingsKey.language,
        store: UserDefaults(suiteName: Config.APP_GROUP_NAME)
    )
    private var keyboardLanguageIdentifier = KeyboardLanguage.deviceDefault.rawValue

    @AppStorage(
        KeyboardSettingsKey.isSystemFontAndSize,
        store: UserDefaults(suiteName: Config.APP_GROUP_NAME)
    )
    private var isKeyboardSystemFontAndSize = true

    @AppStorage(
        KeyboardSettingsKey.isAudioFeedback,
        store: UserDefaults(suiteName: Config.APP_GROUP_NAME)
    )
    private var isKeyboardAudioFeedback = false

    @AppStorage(
        KeyboardSettingsKey.isAutocapitalizationEnabled,
        store: UserDefaults(suiteName: Config.APP_GROUP_NAME)
    )
    private var isKeyboardAutocapitalizationEnabled = true

    var body: some View {
        List {
            Section {
                Picker("Keyboard layout", selection: keyboardLanguage) {
                    ForEach(KeyboardLanguage.allCases) { language in
                        Text(language.localizedName)
                            .tag(language)
                    }
                }
                .pickerStyle(.menu)

                VStack(
                    alignment: .leading,
                    spacing: SettingsMetrics.letterStyleSpacing
                ) {
                    Picker("Letter style", selection: keyboardLetterStyle) {
                        ForEach(LetterStyle.allCases, id: \.self) { style in
                            Text(style.title)
                                .tag(style)
                        }
                    }
                    .pickerStyle(.menu)

                    Text(SettingsText.letterStylePreview)
                        .font(keyboardLetterStyle.wrappedValue.previewFont)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, SettingsMetrics.previewVerticalPadding)
                        .accessibilityLabel(Text("Letter style"))
                }

                Toggle(
                    "Automatic capital letter at the beginning of a sentence",
                    isOn: $isKeyboardAutocapitalizationEnabled
                )

                Toggle(
                    "Key sound",
                    isOn: $isKeyboardAudioFeedback
                )
            } header: {
                Text("Keyboard")
            } footer: {
                VStack(alignment: .leading) {
                    Text("The initial layout is selected from the device language. You can change it at any time.")
                    Text("The selected style changes how letters appear on keyboard keys.")
                    Text("Automatic capitalization and key sound settings.")
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension SettingsView {

    private var keyboardLanguage: Binding<KeyboardLanguage> {
        Binding(
            get: {
                KeyboardLanguage(rawValue: keyboardLanguageIdentifier)
                    ?? KeyboardLanguage.deviceDefault
            },
            set: { language in
                keyboardLanguageIdentifier = language.rawValue
            }
        )
    }

    private var keyboardLetterStyle: Binding<LetterStyle> {
        Binding(
            get: {
                isKeyboardSystemFontAndSize ? .angular : .rounded
            },
            set: { style in
                // Сохраняем прежний логический ключ, чтобы у существующих
                // пользователей выбранное начертание не изменилось после обновления.
                isKeyboardSystemFontAndSize = style == .angular
            }
        )
    }
}

struct SettingsView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationStack {
            SettingsView()
        }
    }
}
