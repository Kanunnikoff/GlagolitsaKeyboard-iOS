//
//  RequestReviewViewModifier.swift
//  GlagolitsaKeyboard
//

import StoreKit
import SwiftUI

struct RequestReviewViewModifier: ViewModifier {

    private enum StorageKey {

        static let launchesCount = "Util.launchesCount"
        static let lastVersionPromtedForReview = "Util.lastVersionPromtedForReview"
    }

    private enum Metrics {

        static let requestDelaySeconds: TimeInterval = 1
    }

    @AppStorage(StorageKey.launchesCount)
    private var launchesCount = 0

    @AppStorage(StorageKey.lastVersionPromtedForReview)
    private var lastVersionPromtedForReview = ""

    // Настоящее системное действие доступно только свойству представления
    // или его модификатора, находящегося в активной иерархии SwiftUI.
    @Environment(\.requestReview)
    private var requestReview

    func body(content: Content) -> some View {
        content
            .onAppear {
                requestReviewIfNeeded()
            }
    }
}

private extension RequestReviewViewModifier {

    func requestReviewIfNeeded() {
        launchesCount += 1

        let currentVersion = Util.getAppBuild()
        guard launchesCount >= Config.REQUEST_REVIEW_LAUNCHES_COUNT_THRESHOLD,
              currentVersion != lastVersionPromtedForReview else {
            return
        }

        // Небольшая задержка позволяет корневому интерфейсу полностью появиться:
        // запрос, вызванный во время построения экрана, система может проигнорировать.
        DispatchQueue.main.asyncAfter(deadline: .now() + Metrics.requestDelaySeconds) {
            requestReview()
            lastVersionPromtedForReview = currentVersion
        }
    }
}

extension View {

    func requestReview() -> some View {
        modifier(RequestReviewViewModifier())
    }
}
