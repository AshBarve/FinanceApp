import SwiftUI

public struct PhoneField: View {
    let label: String
    let placeholder: String
    @Binding var countryCode: String
    @Binding var phoneNumber: String

    public init(
        label: String,
        placeholder: String,
        countryCode: Binding<String>,
        phoneNumber: Binding<String>
    ) {
        self.label = label
        self.placeholder = placeholder
        self._countryCode = countryCode
        self._phoneNumber = phoneNumber
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
            Text(label)
                .font(.appLabel)
                .foregroundColor(.appTextPrimary)

            HStack(spacing: DesignTokens.Spacing.medium) {
                // Country Code Picker
                HStack {
                    Text("🇺🇸")
                    Text(countryCode)
                        .font(.appInput)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(.appTextSecondary)
                }
                .padding()
                .frame(height: DesignTokens.Size.inputHeight)
                .background(Color.white)
                .cornerRadius(DesignTokens.CornerRadius.input)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.input)
                        .stroke(Color.appBorder, lineWidth: 1)
                )

                // Phone Number Field
                TextField(placeholder, text: $phoneNumber)
                    .font(.appInput)
                    .foregroundColor(.appTextPrimary)
                    .keyboardType(.phonePad)
                    .padding()
                    .frame(height: DesignTokens.Size.inputHeight)
                    .background(Color.white)
                    .cornerRadius(DesignTokens.CornerRadius.input)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.input)
                            .stroke(Color.appBorder, lineWidth: 1)
                    )
            }
        }
    }
}
