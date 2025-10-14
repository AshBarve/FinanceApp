import SwiftUI
import MBProgressHUD  // Now available via SPM dependency!

public struct CreateAccountView: View {
    let screenConfig: ScreenModel
    @StateObject private var viewModel = CreateAccountViewModel()
    let onContinue: () -> Void

    public init(
        screenConfig: ScreenModel,
        onContinue: @escaping () -> Void
    ) {
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
