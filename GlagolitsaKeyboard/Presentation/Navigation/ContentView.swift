//
//  ContentView.swift
//  GlagolitsaKeyboard
//
//  Created by Дмитрiй Канунниковъ on 09.07.2022.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    
    private let LAUNCHES_COUNT_THRESHOLD = 5
    
    @State private var selection: SidebarItem? = SidebarItem.main
    @State private var path = NavigationPath()
    
#if !os(tvOS) && !os(watchOS)
    @AppStorage("ContentView.launchesCount")
    private var launchesCount: Int = 0
    
    @AppStorage("ContentView.lastVersionPromtedForReview")
    private var lastVersionPromtedForReview: String = ""
    
    @Environment(\.requestReview) var requestReview
#endif
    
    var body: some View {
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
#if os(macOS)
        .frame(minWidth: 600, minHeight: 450)
#endif
#if !os(tvOS)
        .onAppear {
            requestReviewIfNeeded()
        }
#endif
    }
    
#if !os(tvOS) && !os(watchOS)
    private func requestReviewIfNeeded() {
        launchesCount += 1
        
        // Get the current bundle version for the app
        let currentVersion = Util.getAppBuild()
        
        // Has the process been completed several times and the user has not already been prompted for this version?
        if launchesCount >= LAUNCHES_COUNT_THRESHOLD && currentVersion != lastVersionPromtedForReview {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                requestReview()
                lastVersionPromtedForReview = currentVersion
            }
        }
    }
#endif
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    
    struct Preview: View {
        
        var body: some View {
            ContentView()
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
#endif
