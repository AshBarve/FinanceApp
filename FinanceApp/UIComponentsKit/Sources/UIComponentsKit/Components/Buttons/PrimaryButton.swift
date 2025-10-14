import SwiftUI

public struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true

    public init(title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some View {
        Button(action: {
            print("🔵 PrimaryButton tapped: \(title)")
            action()
        }) {
            Text(title)
                .font(.appButton)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: DesignTokens.Size.buttonHeight)
                .background(isEnabled ? Color.appPrimary : Color.appTextPlaceholder)
                .cornerRadius(DesignTokens.CornerRadius.button)
        }
        .disabled(!isEnabled)
    }
}
