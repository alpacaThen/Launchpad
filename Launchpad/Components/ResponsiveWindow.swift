import AppKit
import SwiftUI

class ResponsiveWindow: NSWindow {
    private nonisolated(unsafe) var overlayObserver: NSObjectProtocol?
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
    }
    
    deinit {
        if let observer = overlayObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    // DRASTIC: Override makeFirstResponder to be very aggressive about TextFields
    override func makeFirstResponder(_ responder: NSResponder?) -> Bool {
        let result = super.makeFirstResponder(responder)
        
        // If we're trying to make a text field first responder and it failed,
        // try again more aggressively
        if !result, let textField = responder as? NSTextField {
            // Force the window to be key first
            if !isKeyWindow {
                makeKey()
            }
            
            // Try again after ensuring window is key
            DispatchQueue.main.async { [weak self] in
                _ = self?.superMakeFirstResponder(textField)
            }
            
            return true // Pretend it succeeded
        }
        
        return result
    }
    
    private func superMakeFirstResponder(_ responder: NSResponder) -> Bool {
        return super.makeFirstResponder(responder)
    }
    
    // DRASTIC: When window becomes key, automatically restore focus to a TextField
    override func becomeKey() {
        super.becomeKey()
        
        // If there's no first responder or it's the window itself, find a text field
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if self.firstResponder == self || self.firstResponder == nil {
                self.findAndFocusTextField()
            }
        }
    }

    
    private func handleOverlayDismissed() {
        // When an overlay is dismissed, aggressively restore focus
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            guard let self = self else { return }
            
            // Make sure we're the key window
            NSApp.activate(ignoringOtherApps: true)
            self.makeKey()
            
            // Find and focus the first available text field
            self.findAndFocusTextField()
        }
    }
    
    private func findAndFocusTextField() {
        guard let contentView = contentView else { return }
        
        if let textField = findFirstTextField(in: contentView) {
            // Try multiple times to ensure it takes
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
        // Check if this view is a text field and is visible/enabled
        if let textField = view as? NSTextField,
           !textField.isHidden,
           textField.isEnabled,
           !textField.refusesFirstResponder,
           textField.acceptsFirstResponder,
           view.window != nil {
            return textField
        }
        
        // Recursively search subviews
        for subview in view.subviews {
            if let textField = findFirstTextField(in: subview) {
                return textField
            }
        }
        
        return nil
    }
}
