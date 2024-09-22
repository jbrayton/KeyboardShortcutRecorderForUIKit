//
//  KEYKeyboardShortcutField.swift
//
//  Created by John Brayton on 9/10/24.
//

import UIKit

public class KEYKeyboardShortcutField : UIControl {
    
    // MARK: Constants
    
	/*
		The “Press Shortcut” and “Record Shortcut” wording was copied directly from 
		KeyboardShortcuts by Sindre Sorhus. 
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
    static let focusedPlaceholderText = String.localizedStringWithFormat("Press Shortcut")
    static let unfocusedPlaceholderText = String.localizedStringWithFormat("Record Shortcut")
    
    // MARK: Simple variables
    
    var label: UILabel!
    var clearButton: KEYClearButton!
    public weak var shortcutFieldDelegate: KEYKeyboardFieldDelegateType?
    var widthConstraint: NSLayoutConstraint!
    var labelTrailingConstraint: NSLayoutConstraint!
    
    // MARK: The shortcut itself
    
    public var shortcut: KEYKeyboardShortcut? {
        didSet {
            self.updateSubviews()
        }
    }
    
    // MARK: Colors and fonts
    
    public var textColor = UIColor.label {
        didSet {
            self.updateSubviews()
        }
    }
    public var disabledTextColor = UIColor.secondaryLabel {
        didSet {
            self.updateSubviews()
        }
    }
    
    public var placeholderTextColor = UIColor.placeholderText {
        didSet {
            self.updateSubviews()
        }
    }
    
    public var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize) {
        didSet {
            self.label.font = font
            self.widthConstraint.constant = KEYKeyboardShortcutField.width(forFont: font)
        }
    }
    public var placeholderColor = UIColor.placeholderText {
        didSet {
            self.updateSubviews()
        }
    }
    
    public var focusedBezelColor = UIColor.secondaryLabel {
        didSet {
            if self.isFirstResponder {
                self.setNeedsDisplay()
            }
        }
    }
    public var unfocusedBezelColor = UIColor.systemGray2 {
        didSet {
            if !self.isFirstResponder {
                self.setNeedsDisplay()
            }
        }
    }
    
    public var disabledBezelColor = UIColor.systemGray4 {
        didSet {
            if !self.isFirstResponder {
                self.setNeedsDisplay()
            }
        }
    }
    
    public var enabledClearButtonColor = UIColor.secondaryLabel {
    	didSet {
    		self.clearButton.enabledColor = self.enabledClearButtonColor
    	}
    }
    
    public var disabledClearButtonColor = UIColor.tertiaryLabel {
    	didSet {
    		self.clearButton.disabledColor = self.disabledClearButtonColor
    	}
    }
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sendActions(for: .allEditingEvents)
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        self.label = UILabel()
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.textAlignment = .center
        self.label.font = font
        
        self.clearButton = KEYClearButton()
        self.clearButton.translatesAutoresizingMaskIntoConstraints = false
        self.clearButton.enabledColor = self.enabledClearButtonColor
        self.clearButton.disabledColor = self.disabledClearButtonColor
        self.clearButton.addTarget(self, action: #selector(handleClearButton(_:)), for: .touchUpInside)
        self.addSubview(self.clearButton)
        self.addSubview(self.label)
        let topBottomSpacing: CGFloat = 5.0
        
        if self.shortcut == nil {
            self.labelTrailingConstraint = self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        } else {
            self.labelTrailingConstraint = self.label.trailingAnchor.constraint(equalTo: self.clearButton.centerXAnchor)
        }
        
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: KEYKeyboardShortcutField.width(forFont: self.font))
        self.addConstraints([
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.label.topAnchor.constraint(equalTo: self.topAnchor, constant: topBottomSpacing),
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0-topBottomSpacing),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.labelTrailingConstraint,
            self.widthConstraint,
            
            self.clearButton.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.clearButton.widthAnchor.constraint(equalTo: self.heightAnchor),
            self.clearButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.clearButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        self.updateSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var isEnabled: Bool {
        didSet {
            self.updateSubviews()
            self.setNeedsDisplay()
            if !isEnabled && isFirstResponder {
                let _ = self.endEditing(true)
            }
            self.clearButton.isEnabled = self.isEnabled
        }
    }
    
    override public func draw(_ rect: CGRect) {
        let cornerRadius = 5.0
        super.draw(rect)
        if self.isFirstResponder {
            let border = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 1, dy: 1), cornerRadius: cornerRadius)
            self.focusedBezelColor.setStroke()
            border.lineWidth = 2.0
            border.stroke()
        } else {
            let border = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 1, dy: 1), cornerRadius: cornerRadius)
            if self.isEnabled {
                self.unfocusedBezelColor.setStroke()
            } else {
                self.disabledBezelColor.setStroke()
            }
            border.lineWidth = 0.5
            border.stroke()
        }
    }
    
    // MARK: Handle clear button
    
    @objc func handleClearButton( _ input: KEYClearButton ) {
        self.clearShortcut()
    }
    
    func clearShortcut() {
        Task { [weak self] in
            if self?.shortcut != nil {
                self?.shortcut = nil
                await self?.shortcutFieldDelegate?.setShortcut(shortcut: nil)
            }
            if self?.isFirstResponder == false {
                let _ = self?.becomeFirstResponder()
            }
            UIAccessibility.post(notification: .announcement, argument: KEYKeyboardShortcutField.focusedPlaceholderText)
        }
    }
    
    // MARK: Update the label based on a shortcut or first responder change
    
    func updateSubviews() {
        if let shortcut = self.shortcut {
            self.label.text = shortcut.userDisplayDescription
            self.label.accessibilityLabel = shortcut.accessibilityDescription
            if self.isEnabled {
                self.label.textColor = self.textColor
            } else {
                self.label.textColor = self.disabledTextColor
            }
        } else if self.isFirstResponder {
            self.label.text = KEYKeyboardShortcutField.focusedPlaceholderText
            self.label.textColor = self.placeholderColor
            self.label.accessibilityLabel = KEYKeyboardShortcutField.focusedPlaceholderText
        } else {
            self.label.text = KEYKeyboardShortcutField.unfocusedPlaceholderText
            self.label.textColor = self.placeholderColor
            self.label.accessibilityLabel = KEYKeyboardShortcutField.unfocusedPlaceholderText
        }
        self.clearButton.isHidden = self.shortcut == nil
        self.clearButton.isAccessibilityElement = false
        self.removeConstraint(self.labelTrailingConstraint)
        if self.shortcut == nil {
            self.labelTrailingConstraint = self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        } else {
            self.labelTrailingConstraint = self.label.trailingAnchor.constraint(equalTo: self.clearButton.centerXAnchor)
        }
        self.addConstraint(self.labelTrailingConstraint)
    }
    
    // MARK: First Responder
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
    
    public override var canResignFirstResponder: Bool {
        return true
    }
    
    override public func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        self.updateSubviews()
        self.setNeedsDisplay()
        UIAccessibility.post(notification: .announcement, argument: String.localizedStringWithFormat("Enter the new shortcut on a hardware keyboard."))
        return result
    }
    
    override public func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        self.updateSubviews()
        self.setNeedsDisplay()
        return result
    }
    
    // MARK: Handle Touch
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        self.becomeFirstResponder()
        return true
    }
    
    // MARK: Keyboard Press Events
    
    override public func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard self.isFirstResponder else {
            super.pressesBegan(presses, with: event)
            return
        }
        for press in presses {
            if let key = press.key {
                
                let characters = key.charactersIgnoringModifiers
                
                if [UIKeyCommand.inputEscape, "\t"].contains(key.characters) {
                    let _ = self.endEditing(true)
                    if let shortcut = self.shortcut {
                        UIAccessibility.post(notification: .announcement, argument: String.localizedStringWithFormat("Shortcut left at %@", shortcut.userDisplayDescription))
                    } else {
                        UIAccessibility.post(notification: .announcement, argument: String.localizedStringWithFormat("Shortcut left blank"))
                    }
                    return
                }
                
                if key.characters == UIKeyCommand.inputDelete {
                    self.clearShortcut()
                    return
                }
                
                if !characters.isEmpty {
                    Task { [weak self] in
                        
                        var modifierFlags = key.modifierFlags
                        
                        let ignoreFlags: [UIKeyModifierFlags] = [.alphaShift, .numericPad]
                        for ignoreFlag in ignoreFlags {
                            if modifierFlags.contains(ignoreFlag) {
                                modifierFlags.remove(ignoreFlag)
                            }
                        }

                        let newShortcut = KEYKeyboardShortcut(input: characters, modifierFlags: modifierFlags)
                        if self?.shortcut != newShortcut {
                            if await self?.shortcutFieldDelegate?.setShortcut(shortcut: newShortcut) == true {
                                self?.shortcut = newShortcut
                                UIAccessibility.post(notification: .announcement, argument: String.localizedStringWithFormat("Shortcut set to %@", newShortcut.accessibilityDescription))
                            }
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
    
    // MARK: Width
    
    static func width( forFont font: UIFont ) -> CGFloat {
        return NSAttributedString(string: KEYKeyboardShortcutField.unfocusedPlaceholderText, attributes: [.font: font]).size().width + 40.0
    }
    
}
