//
//  SettingsView.swift
//  GlagolitsaKeyboard
//
//  Created by Дмитрiй Канунниковъ on 13.09.2022.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("SettingsView.Keyboard.isSystemFontAndSize", store: UserDefaults(suiteName: Config.APP_GROUP_NAME))
    private var isKeyboardSystemFontAndSize: Bool = true
    
    @AppStorage("SettingsView.Keyboard.isAudioFeedback", store: UserDefaults(suiteName: Config.APP_GROUP_NAME))
    private var isKeyboardAudioFeedback: Bool = false
    
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
#if os(iOS)
        .listStyle(.insetGrouped)
#elseif !os(tvOS) && !os(watchOS)
        .listStyle(.inset)
#endif
        .navigationTitle("Settings")
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif
