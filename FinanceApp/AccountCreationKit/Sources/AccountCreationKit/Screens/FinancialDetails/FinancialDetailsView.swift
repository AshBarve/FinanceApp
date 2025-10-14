import SwiftUI

public struct FinancialDetailsView: ABView {
    public typealias ViewModel = FinancialDetailsViewModel

    let screenConfig: ScreenModel
    @ObservedObject public var viewModel: FinancialDetailsViewModel
    let onContinue: () -> Void

    public init(
        screenConfig: ScreenModel,
        viewModel: FinancialDetailsViewModel,
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
