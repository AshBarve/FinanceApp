import SwiftUI

public struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appButton)
                .foregroundColor(.appPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: DesignTokens.Size.buttonHeight)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.button)
                        .stroke(Color.appBorder, lineWidth: 1.5)
                )
                .cornerRadius(DesignTokens.CornerRadius.button)
        }
    }
}
