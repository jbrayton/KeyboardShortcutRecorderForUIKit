//
//  KEYKeyboardField.swift
//
//  Created by John Brayton on 9/10/24.
//

import UIKit

public class KEYKeyboardField : UITextField {
    
    public weak var shortcutFieldDelegate: KEYKeyboardFieldDelegateType?
    
    let focusedPlaceholderText = String.localizedStringWithFormat("Press Shortcut")
    let unfocusedPlaceholderText = String.localizedStringWithFormat("Record Shortcut")
    
    public var placeholderFont: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize) {
        didSet {
            self.updateAttributedPlaceholder()
        }
    }
    public var placeholderColor = UIColor.placeholderText {
        didSet {
            self.updateAttributedPlaceholder()
        }
    }
    
    public var focusedBezelColor = UIColor.label {
        didSet {
            if self.isFirstResponder {
                self.setNeedsDisplay()
            }
        }
    }
    public var unfocusedBezelColor = UIColor.secondaryLabel {
        didSet {
            if !self.isFirstResponder {
                self.setNeedsDisplay()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.updatePlaceholderText(unfocusedPlaceholderText)
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.borderStyle = .none
        self.clearButtonMode = .always
        self.tintColor = .clear
        self.textAlignment = .center
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var shortcut: KEYKeyboardShortcut? {
        didSet {
            if let shortcut {
                self.text = shortcut.userDisplayDescription
            } else {
                self.text = ""
            }
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        var result = super.intrinsicContentSize
        result.height = result.height + 10.0
        return result
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.isFirstResponder {
            let border = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 2, dy: 2), cornerRadius: 10.0)
            self.focusedBezelColor.setStroke()
            border.lineWidth = 4.0
            border.stroke()
        } else {
            let border = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 1, dy: 1), cornerRadius: 10.0)
            self.unfocusedBezelColor.setStroke()
            border.lineWidth = 1.0
            border.stroke()
        }
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        if self.text?.isEmpty == false {
            return CGRect(x: 14, y: 0, width: bounds.size.width - (3*14), height: bounds.height)
        } else {
            return bounds
        }
    }
    
    
    
    override public func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard self.isFirstResponder else {
            super.pressesBegan(presses, with: event)
            return
        }
        for press in presses {
            if let key = press.key {
                
                let characters = key.charactersIgnoringModifiers

                if key.characters == UIKeyCommand.inputEscape {
                    let _ = self.endEditing(true)
                    return
                }
                

                if !characters.isEmpty {
                    Task { [weak self] in
                        let newShortcut = KEYKeyboardShortcut(input: characters, modifierFlags: key.modifierFlags)
                        if await self?.shortcutFieldDelegate?.setShortcut(shortcut: newShortcut) == true {
                            self?.shortcut = newShortcut
                        }
                    }
                    let _ = self.endEditing(true)
                }
            }
        }
    }
    
    override public func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if !self.isFirstResponder {
            super.pressesEnded(presses, with: event)
        }
    }
    
    override public func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if !self.isFirstResponder {
            super.pressesChanged(presses, with: event)
        }
    }
    
    override public func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if !self.isFirstResponder {
            super.pressesCancelled(presses, with: event)
        }
    }
    
    private func updatePlaceholderText( _ value: String ) {
        self.attributedPlaceholder = NSAttributedString(string: value, attributes: [.font: self.placeholderFont, .foregroundColor: self.placeholderColor])
    }
    
    private func updateAttributedPlaceholder() {
        if self.isFirstResponder {
            self.updatePlaceholderText(focusedPlaceholderText)
        } else {
            self.updatePlaceholderText(unfocusedPlaceholderText)
        }
    }
    
}

extension KEYKeyboardField : UITextFieldDelegate {
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.shortcut = nil
        let _ = self.becomeFirstResponder()
        Task { [weak self] in
            // It is assumed that setting the shortcut to nil is always valid.
            let _ = await self?.shortcutFieldDelegate?.setShortcut(shortcut: nil)
        }
        return false
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.updateAttributedPlaceholder()
        self.setNeedsDisplay()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.updateAttributedPlaceholder()
        self.setNeedsDisplay()
    }
    
}
