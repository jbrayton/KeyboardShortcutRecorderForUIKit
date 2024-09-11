//
//  KEYKeyboardField.swift
//  KeyboardExperiment
//
//  Created by John Brayton on 9/10/24.
//

import UIKit

public class KEYKeyboardField : UITextField {
    
    public weak var shortcutFieldDelegate: KEYKeyboardFieldDelegateType?
    
    static let firstResponderPlaceholder = String.localizedStringWithFormat("Press Shortcut on Hardware Keyboard")
    static let notFirstResponderPlaceholder = String.localizedStringWithFormat("Record Shortcut on Hardware Keyboard")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.placeholder = KEYKeyboardField.notFirstResponderPlaceholder
        self.autocorrectionType = .no
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var shortcut: KEYKeyboardShortcut? {
        didSet {
            if let shortcut {
                self.text = shortcut.userDisplayDescription
            } else {
                self.text = ""
            }
        }
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            if let key = press.key {
                
                let characters = key.charactersIgnoringModifiers

                if key.characters == UIKeyCommand.inputEscape {
                    let _ = self.resignFirstResponder()
                    return
                }
                

                if !characters.isEmpty {
                    Task { [weak self] in
                        let newShortcut = KEYKeyboardShortcut(input: characters, modifierFlags: key.modifierFlags)
                        if await self?.shortcutFieldDelegate?.setShortcut(shortcut: newShortcut) == true {
                            self?.shortcut = newShortcut
                        }
                    }
                    let _ = self.resignFirstResponder()
                }
            }
        }
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
    }
    
    override func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
    }
    
    override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
    }
    
}

extension KEYKeyboardField : UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.shortcut = nil
        let _ = self.becomeFirstResponder()
        Task { [weak self] in
            // It is assumed that setting the shortcut to nil is always valid.
            let _ = await self?.shortcutFieldDelegate?.setShortcut(shortcut: nil)
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.placeholder = KEYKeyboardField.firstResponderPlaceholder
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.placeholder = KEYKeyboardField.notFirstResponderPlaceholder
    }
    
}
