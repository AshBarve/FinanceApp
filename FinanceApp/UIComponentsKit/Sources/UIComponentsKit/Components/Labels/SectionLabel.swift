import SwiftUI

public struct SectionLabel: View {
    let text: String
    let style: String

    public init(text: String, style: String = "section") {
        self.text = text
        self.style = style
    }

    public var body: some View {
        Text(text)
            .font(fontForStyle())
            .foregroundColor(.appTextPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, paddingTopForStyle())
            .padding(.bottom, paddingBottomForStyle())
    }

    private func fontForStyle() -> Font {
        switch style {
        case "section":
            return .system(size: 15, weight: .medium)
        case "subsection":
            return .system(size: 13, weight: .medium)
        default:
            return .system(size: 15, weight: .medium)
        }
    }

    private func paddingTopForStyle() -> CGFloat {
        switch style {
        case "section":
            return DesignTokens.Spacing.medium
        case "subsection":
            return DesignTokens.Spacing.small
        default:
            return DesignTokens.Spacing.medium
        }
    }

    private func paddingBottomForStyle() -> CGFloat {
        return DesignTokens.Spacing.small
    }
}
