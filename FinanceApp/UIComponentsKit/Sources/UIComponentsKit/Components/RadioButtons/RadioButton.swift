import SwiftUI

public struct RadioButtonGroup: View {
    let label: String
    let options: [PickerOption]
    @Binding var selectedOption: String?

    public init(
        label: String,
        options: [PickerOption],
        selectedOption: Binding<String?>
    ) {
        self.label = label
        self.options = options
        self._selectedOption = selectedOption
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
            Text(label)
                .font(.appLabel)
                .foregroundColor(.appTextPrimary)

            VStack(spacing: 0) {
                ForEach(options) { option in
                    RadioButtonRow(
                        option: option,
                        isSelected: selectedOption == option.id,
                        action: { selectedOption = option.id }
                    )
                }
            }
            .background(Color.white)
            .cornerRadius(DesignTokens.CornerRadius.input)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.input)
                    .stroke(Color.appBorder, lineWidth: 1)
            )
        }
    }
}

struct RadioButtonRow: View {
    let option: PickerOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                ZStack {
                    Circle()
                        .stroke(Color.appBorder, lineWidth: 1.5)
                        .frame(width: 24, height: 24)

                    if isSelected {
                        Circle()
                            .fill(Color.appPrimary)
                            .frame(width: 12, height: 12)
                    }
                }

                Text(option.label)
                    .font(.appBody)
                    .foregroundColor(.appTextPrimary)

                Spacer()
            }
            .padding()
            .background(Color.white)
        }
    }
}
