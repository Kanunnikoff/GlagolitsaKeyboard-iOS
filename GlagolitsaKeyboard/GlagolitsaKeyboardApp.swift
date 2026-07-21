//
//  GlagolitsaKeyboardApp.swift
//  GlagolitsaKeyboard
//
//  Created by Дмитрiй Канунниковъ on 09.07.2022.
//

import SwiftUI

@main
struct GlagolitsaKeyboardApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .shop()
        }
    }
}
