//
//  KEYKeyboardField.swift
//
//  Created by John Brayton on 9/10/24.
//

import UIKit

public class KEYKeyboardField : UIControl {
    
    // MARK: Constants
    
    static let focusedPlaceholderText = String.localizedStringWithFormat("Press Shortcut")
    static let unfocusedPlaceholderText = String.localizedStringWithFormat("Record Shortcut")
    
    // MARK: Simple variables
    
    var label: UILabel!
    public weak var shortcutFieldDelegate: KEYKeyboardFieldDelegateType?
    var widthConstraint: NSLayoutConstraint!
    
    // MARK: The shortcut itself
    
    public var shortcut: KEYKeyboardShortcut? {
        didSet {
            self.updateLabel()
        }
    }
    
    // MARK: Colors and fonts
    
    public var textColor = UIColor.label {
        didSet {
            self.updateLabel()
        }
    }
    public var disabledTextColor = UIColor.tertiaryLabel {
        didSet {
            self.updateLabel()
        }
    }
    
    public var placeholderTextColor = UIColor.secondaryLabel {
        didSet {
            self.updateLabel()
        }
    }
    
    public var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize) {
        didSet {
            self.label.font = font
            self.widthConstraint.constant = KEYKeyboardField.width(forFont: font)
        }
    }
    public var placeholderColor = UIColor.placeholderText {
        didSet {
            self.updateLabel()
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
    
    public var disabledBezelColor = UIColor.secondaryLabel {
        didSet {
            if !self.isFirstResponder {
                self.setNeedsDisplay()
            }
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
        self.addSubview(self.label)
        let topBottomSpacing: CGFloat = 5.0
        
#warning("trailing anchor should account for clear button when shortcut is non-nil")
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: KEYKeyboardField.width(forFont: self.font))
        self.addConstraints([
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.label.topAnchor.constraint(equalTo: self.topAnchor, constant: topBottomSpacing),
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0-topBottomSpacing),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.widthConstraint,
        ])
        self.updateLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var isEnabled: Bool {
        didSet {
            self.updateLabel()
            self.setNeedsDisplay()
            if !isEnabled && isFirstResponder {
                let _ = self.endEditing(true)
            }
        }
    }
    
    // MARK: UIView Methods
    
    override public var intrinsicContentSize: CGSize {
        var result = CGSize()
        result.height = result.height + 10.0
        let attributed = NSAttributedString(string: "Record Shortcut", attributes: [.font: self.font])
        result.width = attributed.size().width + 10.0
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
            if self.isEnabled {
                self.unfocusedBezelColor.setStroke()
            } else {
                self.disabledBezelColor.setStroke()
            }
            border.lineWidth = 1.0
            border.stroke()
        }
    }
    
    // MARK: Update the label based on a shortcut or first responder change
    
    func updateLabel() {
        if let shortcut = self.shortcut {
            self.label.text = shortcut.userDisplayDescription
            if self.isEnabled {
                self.label.textColor = self.textColor
            } else {
                self.label.textColor = self.disabledTextColor
            }
        } else if self.isFirstResponder {
            self.label.text = String.localizedStringWithFormat("Press Shortcut")
            self.label.textColor = self.placeholderColor
        } else {
            self.label.text = String.localizedStringWithFormat("Record Shortcut")
            if self.isEnabled {
                self.label.textColor = self.placeholderColor
            } else {
                self.label.textColor = self.disabledTextColor
            }
        }
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
        self.updateLabel()
        self.setNeedsDisplay()
        return result
    }
    
    override public func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        self.updateLabel()
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
                
                if key.characters == UIKeyCommand.inputEscape {
                    let _ = self.endEditing(true)
                    return
                }
                
                if key.characters == UIKeyCommand.inputDelete {
                    Task { [weak self] in
                        if self?.shortcut != nil {
                            self?.shortcut = nil
                            await self?.shortcutFieldDelegate?.setShortcut(shortcut: nil)
                        }
                    }
                    let _ = self.endEditing(true)
                    return
                }
                
                
                if !characters.isEmpty {
                    Task { [weak self] in
                        let newShortcut = KEYKeyboardShortcut(input: characters, modifierFlags: key.modifierFlags)
                        if self?.shortcut != newShortcut {
                            if await self?.shortcutFieldDelegate?.setShortcut(shortcut: newShortcut) == true {
                                self?.shortcut = newShortcut
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
        return NSAttributedString(string: KEYKeyboardField.unfocusedPlaceholderText, attributes: [.font: font]).size().width + 40.0
    }
    
}
