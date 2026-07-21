//
//  MainView.swift
//  GlagolitsaKeyboard
//
//  Created by Дмитрiй Канунниковъ on 13.09.2022.
//

import SwiftUI

struct MainView: View {

    private enum Metrics {

        static let cornerRadius: CGFloat = 15
        static let sectionSpacing: CGFloat = 20
        static let activationGuideTitleBottomPadding: CGFloat = 6
        static let dividerHorizontalPadding: CGFloat = 80
    }

    @AppStorage(
        KeyboardSettingsKey.hasBeenUsed,
        store: UserDefaults(suiteName: Config.APP_GROUP_NAME)
    )
    private var hasUsedKeyboard = false

    @State private var text = ""

    @StateObject private var tipPurchaseController = TipPurchaseController()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Metrics.sectionSpacing) {
                VStack(spacing: Metrics.sectionSpacing) {
                    activationGuide
                    decorativeDivider
                    keyboardDescription
                    decorativeDivider

                    TextField("Check Input", text: $text, axis: .vertical)
                        .lineLimit(...5)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.sentences)
                        .font(.body)
                        .padding(10)
                        .overlay(
                            RoundedRectangle(
                                cornerRadius: 10,
                                style: .continuous
                            )
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }

                Spacer()
            }
            .padding()
        }
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle("Glagolitic")
        .navigationBarTitleDisplayMode(.inline)
        .modifier(TipNavigationSubtitleModifier())
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    tipPurchaseController.purchase()
                } label: {
                    Image(systemName: "cup.and.heat.waves.fill")
                }
                .disabled(tipPurchaseController.isPurchasing)
                .accessibilityLabel("Leave a tip")
            }
        }
        .tips(purchaseController: tipPurchaseController)
    }
}

private struct TipNavigationSubtitleModifier: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.navigationSubtitle("Thank you for the tip!")
        } else {
            content
        }
    }
}

private extension MainView {

    var decorativeDivider: some View {
        Divider()
            .padding(.horizontal, Metrics.dividerHorizontalPadding)
            .accessibilityHidden(true)
    }

    var activationGuide: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 14) {
                ActivationStepView(
                    number: 1,
                    text: "Open Settings → General."
                )

                ActivationStepView(
                    number: 2,
                    text: "Keyboard → Keyboards → Add New Keyboard"
                )

                ActivationStepView(
                    number: 3,
                    text: "Add the “Glagolitic” keyboard.",
                    isCompleted: hasUsedKeyboard
                )

                Divider()

                Label(
                    hasUsedKeyboard
                        ? "The keyboard has already been opened successfully on this device."
                        : "In any regular text field, hold the keyboard switch key and select “Glagolitic”.",
                    systemImage: hasUsedKeyboard ? "checkmark.circle.fill" : "globe"
                )
                .font(.footnote)
                .foregroundStyle(hasUsedKeyboard ? Color.green : Color.secondary)

                Text("iOS uses the system keyboard in password and phone-number fields. Some apps may also block third-party keyboards.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } label: {
            Label("How to enable the keyboard", systemImage: "keyboard")
                .font(.headline)
                .padding(.bottom, Metrics.activationGuideTitleBottomPadding)
        }
    }

    var keyboardDescription: some View {
        VStack(alignment: .leading, spacing: Metrics.sectionSpacing) {
            Text("The keyboard contains all letters of the Glagolitic alphabet.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.subheadline)

            Text("Some letters are available by holding corresponding letters with similar pronunciations.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.subheadline)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .overlay(
            RoundedRectangle(
                cornerRadius: Metrics.cornerRadius,
                style: .continuous
            )
            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: Metrics.cornerRadius,
                style: .continuous
            )
        )
    }
}

private struct ActivationStepView: View {

    let number: Int
    let text: LocalizedStringKey
    var isCompleted = false

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "\(number).circle.fill")
                .foregroundStyle(isCompleted ? Color.green : Color.accentColor)
                .accessibilityHidden(true)

            Text(text)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }
}

struct MainView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationStack {
            MainView()
        }
    }
}
