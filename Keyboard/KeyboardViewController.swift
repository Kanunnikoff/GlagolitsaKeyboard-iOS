//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Дмитрiй Канунниковъ on 09.07.2022.
//

import KeyboardKit

final class KeyboardViewController: KeyboardInputViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        applyAutocapitalizationSetting()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Основное приложение не может узнать состояние системного переключателя
        // сторонней клавиатуры. Эта метка подтверждает, что расширение хотя бы раз
        // действительно было открыто пользователем.
        UserDefaults(suiteName: Config.APP_GROUP_NAME)?.set(
            true,
            forKey: KeyboardSettingsKey.hasBeenUsed
        )
    }

    override func viewWillSetupKeyboardKit() {
        setupKeyboardKit(for: .glagolitic) { [weak self] result in
            guard let self else {
                return
            }

            // KeyboardKit во время настройки заменяет стандартные службы, поэтому
            // пользовательский обработчик устанавливается только после завершения.
            self.state.keyboardContext.locale = .russian
            self.applyAutocapitalizationSetting()

            let actionHandler = MyKeyboardActionHandler(controller: self)
            actionHandler.isAutocapitalizationEnabled = self.isAutocapitalizationEnabled
            self.services.actionHandler = actionHandler

            if case .failure(let error) = result {
                // Необязательная настройка библиотеки не должна оставлять пользователя
                // без клавиатуры: раскладка и обработчик уже установлены явно.
                NSLog("Не удалось полностью настроить KeyboardKit: \(error)")
            }
        }
    }

    override func viewWillSetupInitialKeyboardCase() {
        guard isAutocapitalizationEnabled else {
            setKeyboardCase(.lowercased)
            return
        }

        super.viewWillSetupInitialKeyboardCase()
    }

    override func viewWillSetupKeyboardView() {
        setupKeyboardView { controller in
            KeyboardView(
                services: controller.services,
                state: controller.state
            )
        }
    }
}

private extension KeyboardViewController {

    var isAutocapitalizationEnabled: Bool {
        let userDefaults = UserDefaults(suiteName: Config.APP_GROUP_NAME)

        // Настройку меняет основное приложение в другом процессе. Перед чтением
        // обновляем общий домен, чтобы расширение не использовало прежнее значение.
        userDefaults?.synchronize()

        return userDefaults?.object(
            forKey: KeyboardSettingsKey.isAutocapitalizationEnabled
        ) as? Bool ?? true
    }

    func applyAutocapitalizationSetting() {
        let isEnabled = isAutocapitalizationEnabled

        // При каждом показе клавиатуры переносим значение из общей группы в
        // KeyboardKit и сразу пересчитываем регистр уже отображённой раскладки.
        state.keyboardContext.settings.isAutocapitalizationEnabled = isEnabled

        (services.actionHandler as? MyKeyboardActionHandler)?
            .isAutocapitalizationEnabled = isEnabled

        setKeyboardCase(
            isEnabled
                ? preferredKeyboardCase(for: state.keyboardContext.locale)
                : .lowercased
        )
    }
}

private extension KeyboardApp {

    static let glagolitic = KeyboardApp(
        name: "Glagolitic",
        appGroupId: Config.APP_GROUP_NAME,
        locales: [.russian]
    )
}
