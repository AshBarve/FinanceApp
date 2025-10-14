import SwiftUI
import UIComponentsKit

/// AccountCreationKit RadioGroup Adapter
/// Wraps UIComponentsKit.RadioButtonGroup to insulate from library changes
public struct ACKRadioGroup: View {
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
        // ADAPTER: This is the ONLY place that knows about UIComponentsKit.RadioButtonGroup
        RadioButtonGroup(
            label: label,
            options: options,
            selectedOption: $selectedOption
        )
    }
}
