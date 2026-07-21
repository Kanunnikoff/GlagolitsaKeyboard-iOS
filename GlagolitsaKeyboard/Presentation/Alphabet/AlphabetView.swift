//
//  AlphabetView.swift
//  GlagolitsaKeyboard
//

import SwiftUI

struct AlphabetView: View {

    fileprivate enum Layout {

        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 16
        static let gridSpacing: CGFloat = 12
        static let minimumLetterCardWidth: CGFloat = 72
        static let letterCardHeight: CGFloat = 76
        static let letterCardCornerRadius: CGFloat = 12
    }

    private let gridColumns = [
        GridItem(
            .adaptive(minimum: Layout.minimumLetterCardWidth),
            spacing: Layout.gridSpacing
        )
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Layout.verticalPadding) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Glagolitic alphabet")
                        .font(.headline)

                    Text("Uppercase and lowercase forms of the 47 Glagolitic letters available on the keyboard.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                LazyVGrid(columns: gridColumns, spacing: Layout.gridSpacing) {
                    ForEach(AlphabetData.letters) { letter in
                        AlphabetLetterView(letter: letter)
                    }
                }

                Text("Letters that do not fit on the main layout are available by holding the corresponding keys.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Link(destination: AlphabetData.sourceURL) {
                    Label(
                        "Source: Unicode Glagolitic chart",
                        systemImage: "arrow.up.right.square"
                    )
                    .font(.footnote)
                }
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.vertical, Layout.verticalPadding)
        }
        .navigationTitle("Alphabet")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct AlphabetLetterView: View {

    let letter: AlphabetLetter

    var body: some View {
        VStack(spacing: 2) {
            Text(letter.uppercase)
                .font(.title2.weight(.semibold))

            Text(letter.lowercase)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .minimumScaleFactor(0.75)
        .lineLimit(1)
        .frame(maxWidth: .infinity)
        .frame(height: AlphabetView.Layout.letterCardHeight)
        .background {
            RoundedRectangle(cornerRadius: AlphabetView.Layout.letterCardCornerRadius)
                .fill(Color.secondary.opacity(0.12))
        }
        .accessibilityElement(children: .combine)
    }
}

private struct AlphabetLetter: Identifiable {

    let uppercase: String
    let lowercase: String

    var id: String { lowercase }
}

private enum AlphabetData {

    static let sourceURL = URL(string: "https://www.unicode.org/charts/PDF/U2C00.pdf")!

    // Непрерывный диапазон соответствует буквам, которые реально доступны
    // в основной раскладке или по долгому нажатию, поэтому экран и клавиатура
    // не расходятся при последующих изменениях исторических вариантов письма.
    private static let lowercaseLetters = "ⰰⰱⰲⰳⰴⰵⰶⰷⰸⰹⰺⰻⰼⰽⰾⰿⱀⱁⱂⱃⱄⱅⱆⱇⱈⱉⱊⱋⱌⱍⱎⱏⱐⱑⱒⱓⱔⱕⱖⱗⱘⱙⱚⱛⱜⱝⱞ"

    static let letters = lowercaseLetters.map { lowercaseCharacter in
        let lowercase = String(lowercaseCharacter)

        return AlphabetLetter(
            uppercase: lowercase.uppercased(),
            lowercase: lowercase
        )
    }
}

struct AlphabetView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationStack {
            AlphabetView()
        }
    }
}
