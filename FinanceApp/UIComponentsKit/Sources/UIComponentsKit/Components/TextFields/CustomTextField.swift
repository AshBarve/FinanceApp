import SwiftUI

/// CustomTextField - Now using UIKit UITextField under the hood
/// This proves the adapter pattern works - ACKTextField doesn't need any changes!
public struct CustomTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isDisabled: Bool = false
    var inputFilter: String? = nil
    var errorMessage: String? = nil
    var maxLength: Int? = nil
    var onBlur: (() -> Void)? = nil

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
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
            Text(label)
                .font(.appLabel)
                .foregroundColor(.appTextPrimary)

            // REPLACED: Now using UIKit UITextField instead of SwiftUI TextField
            // All the logic (max length, input filter, onBlur) is handled inside UIKitTextField
            UIKitTextField(
                text: $text,
                placeholder: placeholder,
                keyboardType: keyboardType,
                isDisabled: isDisabled,
                inputFilter: inputFilter,
                maxLength: maxLength,
                onBlur: onBlur,
                hasError: hasError
            )
            .frame(height: DesignTokens.Size.inputHeight)

            // Error message
            if let error = errorMessage, !error.isEmpty {
                Text(error)
                    .font(.system(size: 13))
                    .foregroundColor(.red)
                    .padding(.top, 2)
            }
        }
    }

    private var hasError: Bool {
        return errorMessage != nil && !errorMessage!.isEmpty
    }
}
