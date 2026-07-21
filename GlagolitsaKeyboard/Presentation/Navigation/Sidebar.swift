//
//  Sidebar.swift
//  GlagolitsaKeyboard
//
//  Created by Дмитрiй Канунниковъ on 13.09.2022.
//

import SwiftUI

enum SidebarItem: Hashable {

    case main
    case alphabet
    case settings
    case about
}

struct Sidebar: View {

    @Binding var selection: SidebarItem?

    var body: some View {
        List(selection: $selection) {
            NavigationLink(value: SidebarItem.main) {
                Label("Main", systemImage: "house")
            }

            NavigationLink(value: SidebarItem.alphabet) {
                Label("Alphabet", systemImage: "textformat.abc")
            }

            NavigationLink(value: SidebarItem.settings) {
                Label("Settings", systemImage: "gear")
            }

            NavigationLink(value: SidebarItem.about) {
                Label("About", systemImage: "info.circle")
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Menu")
    }
}

struct Sidebar_Previews: PreviewProvider {

    struct Preview: View {

        @State private var selection: SidebarItem? = .main

        var body: some View {
            Sidebar(selection: $selection)
        }
    }

    static var previews: some View {
        NavigationSplitView {
            Preview()
        } detail: {
            Text("Detail")
        }
    }
}
