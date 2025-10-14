import SwiftUI
import UIComponentsKit

/// AccountCreationKit TextField Adapter
/// Wraps UIComponentsKit.CustomTextField to insulate from library changes
public struct ACKTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType
    var isDisabled: Bool
    var inputFilter: String?
    var errorMessage: String?
    var maxLength: Int?
    var onBlur: (() -> Void)?

    public init(
        label: String,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        isDisabled: Bool = false,
        inputFilter: String? = nil,
        errorMessage: String? = nil,
        maxLength: Int? = nil,
        onBlur: (() -> Void)? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.isDisabled = isDisabled
        self.inputFilter = inputFilter
        self.errorMessage = errorMessage
        self.maxLength = maxLength
        self.onBlur = onBlur
    }

    public var body: some View {
        // ADAPTER: This is the ONLY place that knows about UIComponentsKit.CustomTextField
        CustomTextField(
            label: label,
            placeholder: placeholder,
            text: $text,
            keyboardType: keyboardType,
            isDisabled: isDisabled,
            inputFilter: inputFilter,
            errorMessage: errorMessage,
            maxLength: maxLength,
            onBlur: onBlur
        )
    }
}
