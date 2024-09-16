//
//  KEYKeyboardShortcut.swift
//
//  Created by John Brayton on 9/10/24.
//

import UIKit

extension KEYKeyboardShortcut : Codable {

    enum CodingKeys: String, CodingKey {
        case input
        case modifierFlags
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.input, forKey: .input)
        try container.encode(self.modifierFlags.rawValue, forKey: .modifierFlags)
    }
    
    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let input = try values.decode(String.self, forKey: .input)
        let modifierFlagsRaw = try values.decode(Int.self, forKey: .modifierFlags)
        self.input = input
        self.modifierFlags = UIKeyModifierFlags(rawValue: modifierFlagsRaw)
    }

}