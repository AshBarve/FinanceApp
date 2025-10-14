import SwiftUI
import UIComponentsKit

/// AccountCreationKit Picker Adapter
/// Wraps UIComponentsKit.CustomPicker to insulate from library changes
public struct ACKPicker: View {
    let label: String
    let placeholder: String
    @Binding var selectedOption: String?
    let options: [PickerOption]
    var isDisabled: Bool

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
        // ADAPTER: This is the ONLY place that knows about UIComponentsKit.CustomPicker
        CustomPicker(
            label: label,
            placeholder: placeholder,
            selectedOption: $selectedOption,
            options: options,
            isDisabled: isDisabled
        )
    }
}
