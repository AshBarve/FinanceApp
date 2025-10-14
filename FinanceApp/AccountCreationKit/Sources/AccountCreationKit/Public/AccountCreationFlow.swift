import UIKit

public enum AccountCreationResult {
    case completed([String: Any])
    case cancelled
}

// Simple entry point - no longer a SwiftUI View
public class AccountCreationFlow {
    public static func start(
        from navigationController: UINavigationController,
        configuration: FlowConfiguration,
        onCompletion: @escaping (AccountCreationResult) -> Void
    ) {
        let coordinator = AccountCreationCoordinator(
            navigationController: navigationController,
            configuration: configuration,
            onCompletion: onCompletion
        )
        coordinator.start()
    }
}
