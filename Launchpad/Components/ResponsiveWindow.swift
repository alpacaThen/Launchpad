import AppKit

class ResponsiveWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func makeFirstResponder(_ responder: NSResponder?) -> Bool {
        let result = super.makeFirstResponder(responder)
        
        if !result, let textField = responder as? NSTextField {
            if !isKeyWindow {
                makeKey()
            }
            
            DispatchQueue.main.async { [weak self] in
                _ = self?.superMakeFirstResponder(textField)
            }
            
            return true
        }
        
        return result
    }
    
    private func superMakeFirstResponder(_ responder: NSResponder) -> Bool {
        return super.makeFirstResponder(responder)
    }
    
    override func becomeKey() {
        super.becomeKey()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if self.firstResponder == self || self.firstResponder == nil {
                self.findAndFocusTextField()
            }
        }
    }
    
    private func findAndFocusTextField() {
        guard let contentView = contentView else { return }
        
        if let textField = findFirstTextField(in: contentView) {
            _ = makeFirstResponder(textField)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                _ = self?.makeFirstResponder(textField)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                _ = self?.makeFirstResponder(textField)
            }
        }
    }
    
    private func findFirstTextField(in view: NSView) -> NSTextField? {
        if let textField = view as? NSTextField,
           !textField.isHidden,
           textField.isEnabled,
           !textField.refusesFirstResponder,
           textField.acceptsFirstResponder,
           view.window != nil {
            return textField
        }
        
        for subview in view.subviews {
            if let textField = findFirstTextField(in: subview) {
                return textField
            }
        }
        
        return nil
    }
}
