import SwiftUI
import UIComponentsKit

/// AccountCreationKit DateField Adapter
/// Wraps UIComponentsKit.DatePickerField to insulate from library changes
public struct ACKDateField: View {
    let label: String
    let placeholder: String
    @Binding var date: Date?
    let dateFormat: String
    var isDisabled: Bool

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

    public var body: some View {
        // ADAPTER: This is the ONLY place that knows about UIComponentsKit.DatePickerField
        DatePickerField(
            label: label,
            placeholder: placeholder,
            date: $date,
            dateFormat: dateFormat,
            isDisabled: isDisabled
        )
    }
}
