import SwiftUI

public struct MultiSelectPicker: View {
    let label: String
    let placeholder: String
    @Binding var selectedOptions: [String]
    let options: [PickerOption]
    var isDisabled: Bool = false
    @State private var showPicker = false

    public init(
        label: String,
        placeholder: String,
        selectedOptions: Binding<[String]>,
        options: [PickerOption],
        isDisabled: Bool = false
    ) {
        self.label = label
        self.placeholder = placeholder
        self._selectedOptions = selectedOptions
        self.options = options
        self.isDisabled = isDisabled
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
            Text(label)
                .font(.appLabel)
                .foregroundColor(.appTextPrimary)

            Button(action: {
                if !isDisabled {
                    showPicker.toggle()
                }
            }) {
                HStack {
                    Text(displayText())
                        .font(.appInput)
                        .foregroundColor(isDisabled ? .appTextSecondary : (selectedOptions.isEmpty ? .appTextPlaceholder : .appTextPrimary))
                        .lineLimit(2)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(.appTextSecondary)
                }
                .padding()
                .frame(minHeight: DesignTokens.Size.inputHeight)
                .background(isDisabled ? Color.gray.opacity(0.1) : Color.white)
                .cornerRadius(DesignTokens.CornerRadius.input)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.input)
                        .stroke(Color.appBorder, lineWidth: 1)
                )
            }
            .disabled(isDisabled)
            .sheet(isPresented: $showPicker) {
                MultiSelectPickerSheet(selectedOptions: $selectedOptions, options: options, isPresented: $showPicker)
            }

            // Show selected options as chips with remove buttons
            if !selectedOptions.isEmpty {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                    ForEach(selectedOptions, id: \.self) { optionId in
                        if let option = options.first(where: { $0.id == optionId }) {
                            HStack(spacing: DesignTokens.Spacing.small) {
                                Text(option.label)
                                    .font(.system(size: 15))
                                    .foregroundColor(.appTextPrimary)

                                Spacer()

                                Button(action: {
                                    if !isDisabled {
                                        removeOption(optionId)
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.appTextSecondary)
                                }
                                .disabled(isDisabled)
                            }
                            .padding(.vertical, DesignTokens.Spacing.small)
                        }
                    }
                }
                .padding(.top, DesignTokens.Spacing.small)
            }
        }
    }

    private func displayText() -> String {
        if selectedOptions.isEmpty {
            return placeholder
        }

        let count = selectedOptions.count
        return count == 1 ? options.first(where: { $0.id == selectedOptions[0] })?.label ?? placeholder : "\(count) selected"
    }

    private func removeOption(_ optionId: String) {
        selectedOptions.removeAll { $0 == optionId }
    }
}

struct MultiSelectPickerSheet: View {
    @Binding var selectedOptions: [String]
    let options: [PickerOption]
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            List(options) { option in
                Button(action: {
                    toggleSelection(for: option.id)
                }) {
                    HStack {
                        Text(option.label)
                            .font(.appBody)
                            .foregroundColor(.appTextPrimary)
                        Spacer()
                        if selectedOptions.contains(option.id) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.appPrimary)
                        }
                    }
                }
            }
            .navigationTitle("Select Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }

    private func toggleSelection(for id: String) {
        if selectedOptions.contains(id) {
            selectedOptions.removeAll { $0 == id }
        } else {
            selectedOptions.append(id)
        }
    }
}
