import SwiftUI
import UIComponentsKit

/// AccountCreationKit SectionLabel Adapter
/// Wraps UIComponentsKit.SectionLabel to insulate from library changes
public struct ACKSectionLabel: View {
    let text: String
    let style: String

    public init(text: String, style: String = "section") {
        self.text = text
        self.style = style
    }

    public var body: some View {
        // ADAPTER: This is the ONLY place that knows about UIComponentsKit.SectionLabel
        SectionLabel(text: text, style: style)
    }
}
