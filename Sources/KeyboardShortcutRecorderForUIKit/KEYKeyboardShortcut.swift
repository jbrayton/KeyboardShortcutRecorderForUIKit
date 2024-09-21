//
//  KEYKeyboardShortcut.swift
//
//  Created by John Brayton on 9/10/24.
//

import UIKit

public struct KEYKeyboardShortcut : Equatable {

	/*
		The set of strings below was copied directly from KeyboardShortcuts by Sindre
		Sorhus.
		https://github.com/sindresorhus/KeyboardShortcuts
		
		This is the license for that project:
		
		MIT License
		
		Copyright (c) Sindre Sorhus <sindresorhus@gmail.com> (https://sindresorhus.com)
		
		Permission is hereby granted, free of charge, to any person obtaining a copy of 
		this software and associated documentation files (the "Software"), to deal in the 
		Software without restriction, including without limitation the rights to use, 
		copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
		Software, and to permit persons to whom the Software is furnished to do so, 
		subject to the following conditions:
		
		The above copyright notice and this permission notice shall be included in all 
		copies or substantial portions of the Software.
		
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS 
		FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
		COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN 
		AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
		WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	 */
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
        
        UIKeyCommand.f1: "F1",
        UIKeyCommand.f2: "F2",
        UIKeyCommand.f3: "F3",
        UIKeyCommand.f4: "F4",
        UIKeyCommand.f5: "F5",
        UIKeyCommand.f6: "F6",
        UIKeyCommand.f7: "F7",
        UIKeyCommand.f8: "F8",
        UIKeyCommand.f9: "F9",
        UIKeyCommand.f10: "F10",
        UIKeyCommand.f11: "F11",
        UIKeyCommand.f12: "F12"
    ]
    
    public let input: String
    public let modifierFlags: UIKeyModifierFlags
    
    public init( input: String, modifierFlags: UIKeyModifierFlags ) {
        self.input = input
        self.modifierFlags = modifierFlags
    }
    
    @MainActor
    public var userDisplayDescription: String {
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
    public var accessibilityDescription: String {
        var result = ""
        if self.modifierFlags.contains(.control) {
            result = result + "control "
        }
        if self.modifierFlags.contains(.alternate) {
            result = result + "option "
        }
        if self.modifierFlags.contains(.shift) {
            result = result + "shift "
        }
        if self.modifierFlags.contains(.command) {
            result = result + "command "
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
