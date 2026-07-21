//
//  ContentView.swift
//  GlagolitsaKeyboard
//
//  Created by Дмитрiй Канунниковъ on 09.07.2022.
//

import SwiftUI
import UIKit

struct ContentView: View {

    @State private var selection: SidebarItem? = .main
    @State private var path = NavigationPath()

    var body: some View {
        Group {
            if prefersTabNavigation {
                TabNavigationView()
            } else {
                NavigationSplitView {
                    Sidebar(selection: $selection)
                } detail: {
                    NavigationStack(path: $path) {
                        DetailColumn(selection: $selection)
                    }
                }
                .onChange(of: selection) { _ in
                    path.removeLast(path.count)
                }
            }
        }
        .requestReview()
    }

    private var prefersTabNavigation: Bool {
        // Тип устройства проверяется напрямую, чтобы iPad сохранял боковую панель
        // даже в узком окне многозадачности, где класс ширины может стать compact.
        UIDevice.current.userInterfaceIdiom == .phone
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
}
