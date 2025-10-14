import SwiftUI

public struct PersonalDetailsView: ABView {
    public typealias ViewModel = PersonalDetailsViewModel

    let screenConfig: ScreenModel
    @ObservedObject public var viewModel: PersonalDetailsViewModel
    let onContinue: () -> Void

    public init(
        screenConfig: ScreenModel,
        viewModel: PersonalDetailsViewModel,
        onContinue: @escaping () -> Void
    ) {
        self.screenConfig = screenConfig
        self.viewModel = viewModel
        self.onContinue = onContinue
    }

    public var listBody: some View {
        DynamicFormRenderer(
            screenConfig: screenConfig,
            viewModel: viewModel,
            onContinue: onContinue
        )
    }
}
