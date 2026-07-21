//
//  KeyboardView.swift
//  Keyboard
//
//  Created by Дмитрiй Канунниковъ on 09.07.2022.
//

import KeyboardKit
import SwiftUI

struct KeyboardView: View {

    let services: KeyboardServices
    let state: KeyboardState

    var body: some View {
        MyKeyboard(
            services: services,
            state: state
        )
    }
}
