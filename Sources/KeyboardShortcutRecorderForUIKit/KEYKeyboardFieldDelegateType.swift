//
//  KEYKeyboardFieldDelegateType.swift
//  KeyboardExperiment
//
//  Created by John Brayton on 9/10/24.
//

import UIKit

public protocol KEYKeyboardFieldDelegateType : NSObject {
    
    // Should return true if allowed, false if not. The caller is responsible for
    // giving the user and error message or a warning if returning false.
    // This is asynchronous so that the caller can present an alert that lets the user
    // override the warning.
    //
    // This library assumes that setting the shortcut to nil (clearing the shortcut) is
    // always valid, and therefore that calling `setShortcut(shortcut: nil)` always returns
    // true.
    func setShortcut( shortcut: KEYKeyboardShortcut? ) async -> Bool
    
}
