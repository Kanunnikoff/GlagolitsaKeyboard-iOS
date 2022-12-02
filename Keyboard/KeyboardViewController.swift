//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by Дмитрiй Канунниковъ on 09.07.2022.
//

import UIKit
import KeyboardKit
import SwiftUI

class KeyboardViewController: KeyboardInputViewController {
    
    override func viewDidLoad() {
        keyboardContext.locale = KeyboardLocale.russian.locale
        keyboardAppearance = MyKeyboardAppearance(context: keyboardContext)
        
        var glagoliticCalloutActionProvider: LocalizedCalloutActionProvider {
            guard let provider = try? GlagoliticCalloutActionProvider() else {
                fatalError("GlagoliticCalloutActionProvider could not be created.")
            }
            
            return provider
        }
        
        calloutActionProvider = StandardCalloutActionProvider(
            context: keyboardContext,
            providers: [glagoliticCalloutActionProvider]
        )
        
        inputSetProvider = StandardInputSetProvider(
            context: keyboardContext,
            providers: [GlagoliticInputSetProvider()]
        )
        
        keyboardLayoutProvider = StandardKeyboardLayoutProvider(inputSetProvider: inputSetProvider)
        
        keyboardActionHandler = MyKeyboardActionHandler(inputViewController: self)
        
        super.viewDidLoad()
    }
    
    override func viewWillSetupKeyboard() {
        super.viewWillSetupKeyboard()
        
        setup(with: KeyboardView(controller: self))
    }

}
