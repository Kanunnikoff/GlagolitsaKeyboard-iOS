//
//  TipsViewModifier.swift
//  GlagolitsaKeyboard
//

import SwiftUI

struct TipsViewModifier: ViewModifier {

    @ObservedObject var purchaseController: TipPurchaseController

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if purchaseController.isSuccessIndicatorVisible {
                    DoneIndicatorView(
                        message: "Thank you very much for your support!",
                        startImageName: "dollarsign",
                        endImageName: "heart.fill"
                    )
                }
            }
            .alert(
                "Error",
                isPresented: $purchaseController.isErrorAlertVisible,
                actions: {
                    Button("OK", role: .cancel) {
                    }
                },
                message: {
                    Text("I truly appreciate your wish to support the project, but the purchase could not be completed. Please try again later.")
                }
            )
    }
}

extension View {

    func tips(purchaseController: TipPurchaseController) -> some View {
        modifier(TipsViewModifier(purchaseController: purchaseController))
    }
}
