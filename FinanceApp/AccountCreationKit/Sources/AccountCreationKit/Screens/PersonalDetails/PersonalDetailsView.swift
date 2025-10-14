import SwiftUI

public struct PersonalDetailsView: View {
    let screenConfig: ScreenModel
    @StateObject private var viewModel = PersonalDetailsViewModel()
    let onContinue: () -> Void

    public init(screenConfig: ScreenModel, onContinue: @escaping () -> Void) {
        self.screenConfig = screenConfig
        self.onContinue = onContinue
    }

    public var body: some View {
        DynamicFormRenderer(
            screenConfig: screenConfig,
            viewModel: viewModel,
            onContinue: onContinue
        )
    }
}
