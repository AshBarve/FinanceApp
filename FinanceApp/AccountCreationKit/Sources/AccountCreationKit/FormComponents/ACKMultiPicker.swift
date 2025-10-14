import SwiftUI
import UIComponentsKit

/// AccountCreationKit MultiSelectPicker Adapter
/// Wraps UIComponentsKit.MultiSelectPicker to insulate from library changes
public struct ACKMultiPicker: View {
    let label: String
    let placeholder: String
    @Binding var selectedOptions: [String]
    let options: [PickerOption]
    var isDisabled: Bool

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
        // ADAPTER: This is the ONLY place that knows about UIComponentsKit.MultiSelectPicker
        MultiSelectPicker(
            label: label,
            placeholder: placeholder,
            selectedOptions: $selectedOptions,
            options: options,
            isDisabled: isDisabled
        )
    }
}
