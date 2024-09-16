//
//  KEYKeyboardShortcut.swift
//
//  Created by John Brayton on 9/10/24.
//

import UIKit

public struct KEYKeyboardShortcut : Equatable {

    // Some of this was copied directly from KeyboardShortcuts by Sindre Sorhus.
    // https://github.com/sindresorhus/KeyboardShortcuts/blob/main/license
    @MainActor
    static let inputStringDescriptions: [String:String] = [
        " ": "Space",
        "\r": "↩",
        UIKeyCommand.inputDelete: "⌫",
        UIKeyCommand.inputEnd: "↘",
        UIKeyCommand.inputEscape: "⎋",
        UIKeyCommand.inputHome: "↖",
        "\t": "⇥",
        UIKeyCommand.inputPageUp: "⇞",
        UIKeyCommand.inputPageDown: "⇟",
        UIKeyCommand.inputUpArrow: "↑",
        UIKeyCommand.inputDownArrow: "↓",
        UIKeyCommand.inputLeftArrow: "←",
        UIKeyCommand.inputRightArrow: "→",
    ]
    
    let input: String
    let modifierFlags: UIKeyModifierFlags
    
    public init( input: String, modifierFlags: UIKeyModifierFlags ) {
        self.input = input
        self.modifierFlags = modifierFlags
    }
    
    @MainActor
    var userDisplayDescription: String {
        var result = ""
        if self.modifierFlags.contains(.control) {
            result = result + "^"
        }
        if self.modifierFlags.contains(.alternate) {
            result = result + "⌥"
        }
        if self.modifierFlags.contains(.shift) {
            result = result + "⇧"
        }
        if self.modifierFlags.contains(.command) {
            result = result + "⌘"
        }
        result = result + KEYKeyboardShortcut.characterString(forInput: self.input)
        return result
    }
    
    @MainActor
    private static func characterString( forInput input: String ) -> String {
        if let result = KEYKeyboardShortcut.inputStringDescriptions[input] {
            return result
        } else {
            return input.localizedUppercase
        }
    }
    
}
