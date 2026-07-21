//
//  SettingsView.swift
//  GlagolitsaKeyboard
//
//  Created by Дмитрiй Канунниковъ on 13.09.2022.
//

import SwiftUI

struct SettingsView: View {

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

    var body: some View {
        List {
            Section {
                Toggle(
                    "System font and size",
                    isOn: $isKeyboardSystemFontAndSize
                )

                Toggle(
                    "Key sound",
                    isOn: $isKeyboardAudioFeedback
                )
            } header: {
                Text("Keyboard")
            } footer: {
                Text("Ability to enable system font and sound when pressing keys.")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationStack {
            SettingsView()
        }
    }
}
