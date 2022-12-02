//
//  AboutView.swift
//  GlagolitsaKeyboard
//
//  Created by Дмитрiй Канунниковъ on 13.09.2022.
//

import SwiftUI

struct AboutView: View {
    
    private let RU_LOCALE_ID = "ru"
    
    var body: some View {
        List {
            VStack(alignment: .leading) {
                Text("Glagolitic")
                    .font(.headline)
                
                Text("Version \(Util.getAppVersion()), build \(Util.getAppBuild())")
                    .font(.caption)
                
                Text("© 2022 Dmitry Kanunnikoff")
                    .font(.subheadline)
                    .padding(.top, 1)
            }
            
            Section {
                Link("Rate", destination: Config.APPSTORE_APP_REVIEW_URL)
                
#if !os(tvOS)
                ShareLink(item: Config.APPSTORE_APP_URL) {
                    Text("Share")
                }
#endif
                
                Link("Other apps", destination: Config.APPSTORE_DEVELOPER_URL)
                
                Link("Glagolitic: Translator", destination: Config.APPSTORE_GLAGOLITSA_TRANSLATOR_URL)
            } header: {
                Text("App Store")
            } footer: {
                Text("Your opinion is very important to me. Please feel free to rate and write a review.")
            }
            
            Section {
                Link("Write a letter", destination: Config.EMAIL_URL)
                
#if !os(watchOS)
                Link("My YouTube channel", destination: Config.YOUTUBE_URL)
                
                Link("I'm on Twitter", destination: Config.TWITTER_URL)
                
                Link("I'm on Instagram", destination: Config.INSTAGRAM_URL)
#endif
            } header: {
                Text("Feedback")
            } footer: {
                Text("In case of questions or suggestions, I am at your service. Let's be in touch!")
            }
            
#if !os(watchOS)
            Section {
                Link("Read", destination: Config.PRIVACY_POLICY_URL)
            } header: {
                Text("Privacy Policy")
            } footer: {
                Text("Detailed information about how the application uses your data.")
            }
            
            Section {
                Link("Patreon", destination: Config.PATREON)
                
                Link("Buy Me a Coffee", destination: Config.BUY_ME_A_COFFEE)
                
                if Locale.current.language.languageCode?.identifier == RU_LOCALE_ID {
                    Link("Boosty", destination: Config.BOOSTY)
                }
            } header: {
                Text("Support")
            } footer: {
                Text("If you like the result of my work, then you can, if you wish, support me in one of the above ways.")
            }
#endif
        }
        .navigationTitle("About")
    }
}

#if DEBUG
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
#endif
