//
//  KEYKeyboardShortcutUnitTest.swift
//  KeyboardShortcutRecorderForUIKit
//
//  Created by John Brayton on 9/11/24.
//

import Foundation
import Testing
@testable import KeyboardShortcutRecorderForUIKit

struct KEYKeyboardShortcutUnitTest {

    @Test func testEncodableDecodable() async throws {
        let shortcut = KEYKeyboardShortcut(input: "a", modifierFlags: [.command, .alternate])
        let data = try JSONEncoder().encode(shortcut)
        let decoded = try JSONDecoder().decode(KEYKeyboardShortcut.self, from: data)
        #expect(decoded.input == "a")
        #expect(decoded.modifierFlags == [.command, .alternate])
    }

}

