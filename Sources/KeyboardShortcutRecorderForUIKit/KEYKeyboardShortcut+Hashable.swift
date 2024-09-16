//
//  KEYKeyboardShortcut.swift
//
//  Created by John Brayton on 9/10/24.
//

import UIKit

extension KEYKeyboardShortcut : Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.input)
        hasher.combine(self.modifierFlags.rawValue)
    }
    
}
