import SwiftUI

public struct DatePickerField: View {
    let label: String
    let placeholder: String
    @Binding var date: Date?
    let dateFormat: String
    var isDisabled: Bool = false

    public init(
        label: String,
        placeholder: String,
        date: Binding<Date?>,
        dateFormat: String = "MM/dd/yyyy",
        isDisabled: Bool = false
    ) {
        self.label = label
        self.placeholder = placeholder
        self._date = date
        self.dateFormat = dateFormat
        self.isDisabled = isDisabled
    }

    private var formattedDate: String {
        guard let date = date else { return placeholder }
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
            Text(label)
                .font(.appLabel)
                .foregroundColor(.appTextPrimary)

            ZStack {
                // Background container
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.input)
                    .fill(isDisabled ? Color.gray.opacity(0.1) : Color.white)
                    .frame(height: DesignTokens.Size.inputHeight)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.input)
                            .stroke(Color.appBorder, lineWidth: 1)
                    )

                // Date picker (hidden but functional)
                if !isDisabled {
                    DatePicker(
                        "",
                        selection: Binding(
                            get: { date ?? Date() },
                            set: { date = $0 }
                        ),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(0.011) // Nearly invisible but still tappable
                }

                // Display text
                HStack {
                    Text(formattedDate)
                        .font(.appInput)
                        .foregroundColor(isDisabled ? .appTextSecondary : (date != nil ? .appTextPrimary : .appTextPlaceholder))
                    Spacer()
                }
                .padding(.horizontal, 16)
                .allowsHitTesting(false)
            }
            .frame(height: DesignTokens.Size.inputHeight)
        }
    }
}
