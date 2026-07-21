//
//  AboutView.swift
//  GlagolitsaKeyboard
//
//  Created by Дмитрiй Канунниковъ on 13.09.2022.
//

import SwiftUI
import UIKit

struct AboutView: View {

    @StateObject private var tipPurchaseController = TipPurchaseController()

    var body: some View {
        List {
            HStack {
                if let appIconName = Util.getAppIconName(),
                   let image = UIImage(named: appIconName) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .frame(width: 65)
                        .accessibilityHidden(true)
                }

                VStack(alignment: .leading) {
                    Text(Util.getAppDisplayName())
                        .font(.headline)

                    Text("Version \(Util.getAppVersion()), build \(Util.getAppBuild())")
                        .font(.caption)

                    Text("© 2026 Dmitry Kanunnikoff")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 5)
            }
            .frame(maxWidth: .infinity)

            Section {
                Link("Rate", destination: Config.APPSTORE_APP_REVIEW_URL)

                ShareLink(item: Config.APPSTORE_APP_URL) {
                    Text("Share")
                }

                Link("Other apps", destination: Config.APPSTORE_DEVELOPER_URL)

                Link("Glagolitic: Translator", destination: Config.APPSTORE_GLAGOLITSA_TRANSLATOR_URL)
            } header: {
                Text("App Store")
            } footer: {
                Text("Your opinion is very important to me. Please feel free to rate and write a review.")
            }

            Section {
                Link("Write a letter", destination: Config.EMAIL_URL)
            } header: {
                Text("Feedback")
            } footer: {
                Text("In case of questions or suggestions, I am at your service. Let's be in touch!")
            }

            Section {
                Link("Read", destination: Config.PRIVACY_POLICY_URL)
            } header: {
                Text("Privacy Policy")
            } footer: {
                Text("Detailed information about how the application uses your data.")
            }

            Section {
                Button {
                    tipPurchaseController.purchase()
                } label: {
                    HStack {
                        Text("Tip")

                        Spacer()

                        if tipPurchaseController.isPurchasing {
                            ProgressView()
                        }
                    }
                }
                .disabled(tipPurchaseController.isPurchasing)
            } header: {
                Text("Support")
            } footer: {
                Text("If you like the result of my work, you can support me with a tip.")
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
        .tips(purchaseController: tipPurchaseController)
    }
}

struct AboutView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationStack {
            AboutView()
        }
    }
}
