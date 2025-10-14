import SwiftUI
import UIKit

/// UIKit-based TextField wrapped in UIViewRepresentable
/// Proves that the adapter pattern works by replacing SwiftUI TextField with UIKit UITextField
public struct UIKitTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType
    var isDisabled: Bool
    var inputFilter: String?
    var maxLength: Int?
    var onBlur: (() -> Void)?
    var hasError: Bool

    public init(
        text: Binding<String>,
        placeholder: String,
        keyboardType: UIKeyboardType = .default,
        isDisabled: Bool = false,
        inputFilter: String? = nil,
        maxLength: Int? = nil,
        onBlur: (() -> Void)? = nil,
        hasError: Bool = false
    ) {
        self._text = text
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isDisabled = isDisabled
        self.inputFilter = inputFilter
        self.maxLength = maxLength
        self.onBlur = onBlur
        self.hasError = hasError
    }

    public func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator

        // Styling
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.isEnabled = !isDisabled
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = isDisabled ? UIColor.systemGray : UIColor.label

        // Padding
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.rightViewMode = .always

        // Border and background
        textField.backgroundColor = isDisabled ? UIColor.systemGray6 : UIColor.white
        textField.layer.cornerRadius = DesignTokens.CornerRadius.input
        textField.layer.borderWidth = 1
        textField.layer.borderColor = hasError ? UIColor.red.cgColor : UIColor.systemGray4.cgColor

        // Add text change listener
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)

        return textField
    }

    public func updateUIView(_ uiView: UITextField, context: Context) {
        // Update text only if different to avoid cursor jumping
        if uiView.text != text {
            uiView.text = text
        }

        uiView.placeholder = placeholder
        uiView.keyboardType = keyboardType
        uiView.isEnabled = !isDisabled
        uiView.textColor = isDisabled ? UIColor.systemGray : UIColor.label
        uiView.backgroundColor = isDisabled ? UIColor.systemGray6 : UIColor.white
        uiView.layer.borderColor = hasError ? UIColor.red.cgColor : UIColor.systemGray4.cgColor
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, UITextFieldDelegate {
        var parent: UIKitTextField

        init(_ parent: UIKitTextField) {
            self.parent = parent
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            var newText = textField.text ?? ""

            // Apply max length first
            if let maxLen = parent.maxLength, newText.count > maxLen {
                newText = String(newText.prefix(maxLen))
                textField.text = newText
            }

            // Apply input filter
            if let filter = parent.inputFilter, !filter.isEmpty {
                if !applyInputFilter(newText) {
                    // Revert to previous value
                    textField.text = parent.text
                    return
                }
            }

            // Update binding
            parent.text = newText
        }

        private func applyInputFilter(_ newValue: String) -> Bool {
            guard let filter = parent.inputFilter else { return true }

            // Check if the new value matches the regex pattern
            let regex = try? NSRegularExpression(pattern: filter)
            let range = NSRange(location: 0, length: newValue.utf16.count)

            if let regex = regex {
                return regex.firstMatch(in: newValue, range: range) != nil
            }

            return true
        }

        // UITextFieldDelegate methods
        public func textFieldDidEndEditing(_ textField: UITextField) {
            // Call onBlur when field loses focus
            parent.onBlur?()
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
}
