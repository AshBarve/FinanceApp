import SwiftUI
import UIComponentsKit

/// AccountCreationKit PhoneField Adapter
/// Wraps UIComponentsKit.PhoneField to insulate from library changes
public struct ACKPhoneField: View {
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
        // ADAPTER: This is the ONLY place that knows about UIComponentsKit.PhoneField
        PhoneField(
            label: label,
            placeholder: placeholder,
            countryCode: $countryCode,
            phoneNumber: $phoneNumber
        )
    }
}
