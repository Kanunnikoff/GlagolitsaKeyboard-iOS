//
//  TabNavigationView.swift
//  GlagolitsaKeyboard
//

import SwiftUI

private enum TabSelection: Hashable {

    case main
    case alphabet
    case settings
    case about
}

struct TabNavigationView: View {

    @State private var selectedTab: TabSelection = .main

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                MainView()
            }
            .tabItem {
                Label("Main", systemImage: "house")
            }
            .tag(TabSelection.main)

            NavigationStack {
                AlphabetView()
            }
            .tabItem {
                Label("Alphabet", systemImage: "textformat.abc")
            }
            .tag(TabSelection.alphabet)

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(TabSelection.settings)

            NavigationStack {
                AboutView()
            }
            .tabItem {
                Label("About", systemImage: "info.circle")
            }
            .tag(TabSelection.about)
        }
    }
}

struct TabNavigationView_Previews: PreviewProvider {

    static var previews: some View {
        TabNavigationView()
    }
}
