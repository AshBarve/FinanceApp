import SwiftUI

public struct PickerOption: Identifiable, Hashable {
    public let id: String
    public let label: String

    public init(id: String, label: String) {
        self.id = id
        self.label = label
    }
}

public struct CustomPicker: View {
    let label: String
    let placeholder: String
    @Binding var selectedOption: String?
    let options: [PickerOption]
    var isDisabled: Bool = false
    @State private var showPicker = false

    public init(
        label: String,
        placeholder: String,
        selectedOption: Binding<String?>,
        options: [PickerOption],
        isDisabled: Bool = false
    ) {
        self.label = label
        self.placeholder = placeholder
        self._selectedOption = selectedOption
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
                    Text(selectedOption != nil ? options.first(where: { $0.id == selectedOption })?.label ?? placeholder : placeholder)
                        .font(.appInput)
                        .foregroundColor(isDisabled ? .appTextSecondary : (selectedOption != nil ? .appTextPrimary : .appTextPlaceholder))

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(.appTextSecondary)
                }
                .padding()
                .frame(height: DesignTokens.Size.inputHeight)
                .background(isDisabled ? Color.gray.opacity(0.1) : Color.white)
                .cornerRadius(DesignTokens.CornerRadius.input)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.input)
                        .stroke(Color.appBorder, lineWidth: 1)
                )
            }
            .disabled(isDisabled)
            .sheet(isPresented: $showPicker) {
                PickerSheet(selectedOption: $selectedOption, options: options, isPresented: $showPicker)
            }
        }
    }
}

struct PickerSheet: View {
    @Binding var selectedOption: String?
    let options: [PickerOption]
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            List(options) { option in
                Button(action: {
                    selectedOption = option.id
                    isPresented = false
                }) {
                    HStack {
                        Text(option.label)
                            .font(.appBody)
                            .foregroundColor(.appTextPrimary)
                        Spacer()
                        if selectedOption == option.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.appPrimary)
                        }
                    }
                }
            }
            .navigationTitle("Select Option")
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
}
