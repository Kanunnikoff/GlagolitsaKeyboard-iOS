//
//  MyKeyboard.swift
//  keyboard
//
//  Created by Дмитрiй Канунниковъ on 09.07.2022.
//

import KeyboardKit
import SwiftUI

struct MyKeyboard: View {

    @AppStorage(
        KeyboardSettingsKey.isSystemFontAndSize,
        store: UserDefaults(suiteName: Config.APP_GROUP_NAME)
    )
    private var usesSystemFont = true

    private let services: KeyboardServices

    @ObservedObject private var keyboardContext: KeyboardContext

    init(
        services: KeyboardServices,
        state: KeyboardState
    ) {
        self.services = services
        _keyboardContext = ObservedObject(wrappedValue: state.keyboardContext)
    }

    var body: some View {
        KeyboardKit.KeyboardView(
            layout: keyboardLayout,
            services: services,
            buttonContent: { parameters in
                MyKeyboardButtonContent(
                    action: parameters.item.action,
                    keyboardContext: keyboardContext,
                    standardContent: parameters.view
                )
            },
            buttonView: { parameters in
                parameters.view
                    // KeyboardView создаёт собственный стиль внутри построителя
                    // каждой клавиши. Поэтому внешний модификатор перезаписывался,
                    // а стиль нужно применять непосредственно к готовой клавише.
                    .keyboardButtonStyle { styleParameters in
                        MyKeyboardAppearance.buttonStyle(
                            for: styleParameters,
                            usesSystemFont: usesSystemFont
                        )
                    }
            },
            collapsedView: { parameters in
                parameters.view
            },
            emojiKeyboard: { _ in
                MyEmojiKeyboard(
                    services: services,
                    isPadKeyboard: isPadKeyboard
                )
            },
            toolbar: { _ in
                EmptyView()
            }
        )
        .keyboardCalloutActions { parameters in
            customCalloutActions(for: parameters.action) ?? parameters.standardActions()
        }
        .environment(\.layoutDirection, .leftToRight)
    }
}

private extension MyKeyboard {

    var isPadKeyboard: Bool {
        keyboardContext.deviceTypeForKeyboard.isPad
    }

    var keyboardLayout: KeyboardLayout {
        let inputSets = GlagoliticInputSetProvider()

        // Базовый построитель сохраняет служебные клавиши и правильные переходы
        // между буквенным, цифровым и символьным режимами. Пользовательскими
        // остаются только фактические ряды символов глаголической раскладки.
        let baseLayout = KeyboardLayout(
            baseLayoutFor: keyboardContext,
            alphabeticInputSet: inputSets.alphabeticInputSet,
            numericInputSet: inputSets.numericInputSet,
            symbolicInputSet: inputSets.symbolicInputSet
        )

        // Плавающая клавиатура iPad определяется библиотекой как компактная
        // и получает телефонную компоновку, как системная клавиатура iOS.
        if isPadKeyboard {
            return baseLayout.iPadLayout(for: keyboardContext)
        }

        return phoneLayout(
            from: baseLayout.iPhoneLayout(for: keyboardContext)
        )
    }

    func phoneLayout(from layout: KeyboardLayout) -> KeyboardLayout {
        var result = layout

        guard keyboardContext.keyboardType.isAlphabetic else {
            return result
        }

        for rowIndex in result.itemRows.indices.prefix(
            PhoneAlphabeticLayoutMetrics.inputRowCount
        ) {
            let visibleItems = result.itemRows[rowIndex].filter {
                !$0.action.isCharacterMargin
            }

            // KeyboardKit строит буквенные ряды на основе стандартной сетки
            // и добавляет по краям невидимые элементы. В каждом
            // ряду нашей раскладки ровно 11 видимых клавиш, включая Shift и
            // удаление в нижнем ряду, поэтому делим всю ширину на равные ячейки.
            guard visibleItems.count == PhoneAlphabeticLayoutMetrics.columnCount else {
                continue
            }

            result.itemRows[rowIndex] = visibleItems.map { sourceItem in
                var item = sourceItem
                item.size.width = PhoneAlphabeticLayoutMetrics.itemWidth

                return item
            }
        }

        return result
    }

    func customCalloutActions(for action: KeyboardAction) -> [KeyboardAction]? {
        GlagoliticCalloutActionProvider().calloutActions(for: action)
    }
}

private enum PhoneAlphabeticLayoutMetrics {

    static let columnCount = 11
    static let inputRowCount = 3

    static var itemWidth: KeyboardLayoutItem.Width {
        .percentage(1 / CGFloat(columnCount))
    }
}

private extension KeyboardAction {

    var isCharacterMargin: Bool {
        if case .characterMargin = self {
            return true
        }

        return false
    }
}

private struct MyKeyboardButtonContent<StandardContent: View>: View {

    let action: KeyboardAction
    let keyboardContext: KeyboardContext
    let standardContent: StandardContent

    @ViewBuilder
    var body: some View {
        if let title = MyKeyboardAppearance.buttonTitle(for: action) {
            Keyboard.ButtonTitle(
                text: title,
                action: action
            )
            // Стандартное содержимое KeyboardKit добавляет разные отступы для
            // служебных клавиш и устройств. При замене подписи возвращаем их явно.
            .padding(action.standardButtonContentInsets(for: keyboardContext))
        } else {
            standardContent
        }
    }
}

private struct MyEmojiKeyboard: View {

    private enum CompactMetrics {

        static let bottomBarHeight: CGFloat = 44
        static let categoryButtonSize: CGFloat = 36
        static let emojiFontSize: CGFloat = 32
        static let emojiItemHeight: CGFloat = 42
        static let emojiItemWidth: CGFloat = 44
        static let horizontalPadding: CGFloat = 6
        static let rowCount = 4
        static let rowSpacing: CGFloat = 2
    }

    private enum PadMetrics {

        static let bottomBarHeight: CGFloat = 44
        static let categoryButtonSize: CGFloat = 36
        static let columnSpacing: CGFloat = 10
        static let emojiFontSize: CGFloat = 40
        static let emojiItemHeight: CGFloat = 55
        static let emojiItemWidth: CGFloat = 55
        static let horizontalPadding: CGFloat = 20
        static let maximumRowCount = 6
        static let minimumRowCount = 4
        static let rowSpacing: CGFloat = 8
        static let sectionSpacing: CGFloat = 32
        static let sectionTitleBottomSpacing: CGFloat = 10
        static let sectionTitleFontSize: CGFloat = 13
        static let sectionTitleHeight: CGFloat = 16
        static let topPadding: CGFloat = 12
    }

    private let isPadKeyboard: Bool
    private let services: KeyboardServices

    @State private var selectedCategory: EmojiCategory = .smileysAndPeople

    init(
        services: KeyboardServices,
        isPadKeyboard: Bool
    ) {
        self.services = services
        self.isPadKeyboard = isPadKeyboard

        let recentCategory = EmojiCategory.recent
        let initialCategory: EmojiCategory = isPadKeyboard && recentCategory.hasEmojis
            ? recentCategory
            : .smileysAndPeople
        _selectedCategory = State(initialValue: initialCategory)
    }

    var body: some View {
        VStack(spacing: 0) {
            if isPadKeyboard {
                padEmojiGrid
                padBottomBar
            } else {
                compactEmojiGrid
                compactBottomBar
            }
        }
    }
}

private extension MyEmojiKeyboard {

    var emojiLocale: Locale {
        switch Locale.current.language.languageCode?.identifier {
            case "hr":
                return Locale(identifier: "hr")

            case "ru":
                return Locale(identifier: "ru")

            case "uk":
                return Locale(identifier: "uk")

            default:
                return Locale(identifier: "en")
        }
    }

    var categories: [EmojiCategory] {
        let recentCategory = EmojiCategory.recent
        if recentCategory.hasEmojis {
            return [recentCategory] + EmojiCategory.standardCategories
        }

        return EmojiCategory.standardCategories
    }

    var compactEmojiRows: [GridItem] {
        Array(
            repeating: GridItem(
                .fixed(CompactMetrics.emojiItemHeight),
                spacing: CompactMetrics.rowSpacing
            ),
            count: CompactMetrics.rowCount
        )
    }

    var compactEmojiGrid: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(
                rows: compactEmojiRows,
                spacing: CompactMetrics.rowSpacing
            ) {
                ForEach(selectedCategory.emojis) { emoji in
                    emojiButton(
                        emoji,
                        fontSize: CompactMetrics.emojiFontSize,
                        itemWidth: CompactMetrics.emojiItemWidth,
                        itemHeight: CompactMetrics.emojiItemHeight
                    )
                }
            }
            .padding(.horizontal, CompactMetrics.horizontalPadding)
        }
    }

    var compactBottomBar: some View {
        HStack(spacing: 0) {
            Button("ⰀⰁⰂ") {
                services.actionHandler.handle(.keyboardType(.alphabetic))
            }
            .frame(width: CompactMetrics.categoryButtonSize)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(categories) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            category.symbolIcon
                                .frame(
                                    width: CompactMetrics.categoryButtonSize,
                                    height: CompactMetrics.categoryButtonSize
                                )
                                .background(
                                    selectedCategory == category
                                        ? Color.primary.opacity(0.12)
                                        : Color.clear
                                )
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(category.labelText(for: emojiLocale))
                    }
                }
            }

            Button {
                services.actionHandler.handle(.backspace)
            } label: {
                Image(systemName: "delete.left")
            }
            .frame(width: CompactMetrics.categoryButtonSize)
            .accessibilityLabel("Delete")
        }
        .buttonStyle(.plain)
        .frame(height: CompactMetrics.bottomBarHeight)
        .padding(.horizontal, CompactMetrics.horizontalPadding)
    }

    func padEmojiRows(for availableHeight: CGFloat) -> [GridItem] {
        // Расширение получает разную высоту в книжной и альбомной ориентациях.
        // Число строк выводится из фактической высоты и ограничивается диапазоном,
        // который сохраняет читаемый размер эмодзи на всех поддерживаемых iPad.
        let reservedHeight = PadMetrics.topPadding
            + PadMetrics.sectionTitleHeight
            + PadMetrics.sectionTitleBottomSpacing
        let gridHeight = max(0, availableHeight - reservedHeight)
        let rowStride = PadMetrics.emojiItemHeight + PadMetrics.rowSpacing
        let fittingRowCount = Int(
            (gridHeight + PadMetrics.rowSpacing) / rowStride
        )
        let rowCount = min(
            PadMetrics.maximumRowCount,
            max(PadMetrics.minimumRowCount, fittingRowCount)
        )

        return Array(
            repeating: GridItem(
                .fixed(PadMetrics.emojiItemHeight),
                spacing: PadMetrics.rowSpacing
            ),
            count: rowCount
        )
    }

    var padVisibleCategories: [EmojiCategory] {
        // Содержимое не обрывается на границе раздела: справа сразу начинается
        // следующий. Выбор категории переносит начало ленты к нужному разделу.
        guard let selectedIndex = categories.firstIndex(of: selectedCategory) else {
            return [selectedCategory]
        }

        return Array(categories[selectedIndex...])
    }

    var padEmojiGrid: some View {
        GeometryReader { geometry in
            let rows = padEmojiRows(for: geometry.size.height)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(
                    alignment: .top,
                    spacing: PadMetrics.sectionSpacing
                ) {
                    ForEach(padVisibleCategories) { category in
                        padCategorySection(
                            category,
                            rows: rows
                        )
                    }
                }
                // Минимальная высота удерживает содержимое у верхней границы,
                // иначе горизонтальная прокрутка прижимает сетку вниз.
                .frame(
                    minHeight: geometry.size.height,
                    alignment: .top
                )
                .padding(.horizontal, PadMetrics.horizontalPadding)
                .padding(.top, PadMetrics.topPadding)
                .id(selectedCategory)
            }
        }
    }

    func padCategorySection(
        _ category: EmojiCategory,
        rows: [GridItem]
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: PadMetrics.sectionTitleBottomSpacing
        ) {
            Text(
                category.labelText(for: emojiLocale)
                    .uppercased(with: .current)
            )
            .font(
                .system(
                    size: PadMetrics.sectionTitleFontSize,
                    weight: .semibold
                )
            )
            .foregroundStyle(.secondary)

            LazyHGrid(
                rows: rows,
                spacing: PadMetrics.columnSpacing
            ) {
                ForEach(category.emojis) { emoji in
                    emojiButton(
                        emoji,
                        fontSize: PadMetrics.emojiFontSize,
                        itemWidth: PadMetrics.emojiItemWidth,
                        itemHeight: PadMetrics.emojiItemHeight
                    )
                }
            }
        }
        .fixedSize(horizontal: true, vertical: true)
    }

    var padBottomBar: some View {
        HStack(spacing: 0) {
            Button("ⰀⰁⰂ") {
                services.actionHandler.handle(.keyboardType(.alphabetic))
            }
            .frame(width: PadMetrics.categoryButtonSize)
            .frame(maxHeight: .infinity)

            // На узкой и разделённой клавиатуре iPad прокручивается только
            // средняя часть, а переход к буквам и служебные кнопки видны всегда.
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(categories) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            category.symbolIcon
                                .frame(
                                    width: PadMetrics.categoryButtonSize,
                                    height: PadMetrics.categoryButtonSize
                                )
                                .background(
                                    selectedCategory == category
                                        ? Color.primary.opacity(0.12)
                                        : Color.clear
                                )
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(category.labelText(for: emojiLocale))
                    }
                }
            }
            .frame(maxWidth: .infinity)

            Button {
                services.actionHandler.handle(.backspace)
            } label: {
                Image(systemName: "delete.left")
            }
            .frame(width: PadMetrics.categoryButtonSize)
            .frame(maxHeight: .infinity)
            .accessibilityLabel("Delete")

            Button {
                services.actionHandler.handle(.dismissKeyboard)
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
            }
            .frame(width: PadMetrics.categoryButtonSize)
            .frame(maxHeight: .infinity)
            .accessibilityLabel("Hide Keyboard")
        }
        .buttonStyle(.plain)
        .frame(height: PadMetrics.bottomBarHeight)
        .padding(.horizontal, CompactMetrics.horizontalPadding)
    }

    func emojiButton(
        _ emoji: Emoji,
        fontSize: CGFloat,
        itemWidth: CGFloat,
        itemHeight: CGFloat
    ) -> some View {
        Button {
            insert(emoji)
        } label: {
            Text(emoji.char)
                .font(.system(size: fontSize))
                .frame(
                    width: itemWidth,
                    height: itemHeight
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(emoji.localizedName)
    }

    func insert(_ emoji: Emoji) {
        EmojiCategory.Persisted.recent.addEmoji(emoji)
        services.actionHandler.handle(.emoji(emoji))
    }
}
