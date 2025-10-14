import SwiftUI
import UIComponentsKit

/// AccountCreationKit Button Adapter
/// Wraps UIComponentsKit.PrimaryButton to insulate from library changes
public struct ACKButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool

    public init(title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some View {
        // ADAPTER: This is the ONLY place that knows about UIComponentsKit.PrimaryButton
        PrimaryButton(title: title, isEnabled: isEnabled, action: action)
    }
}
