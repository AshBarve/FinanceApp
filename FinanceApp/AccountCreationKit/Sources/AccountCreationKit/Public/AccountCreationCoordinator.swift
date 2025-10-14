import UIKit
import SwiftUI

public class AccountCreationCoordinator: NSObject, UINavigationControllerDelegate {
    private weak var navigationController: UINavigationController?
    private var configuration: FlowConfiguration?
    private let parser = FlowConfigParser()
    private var currentScreenIndex: Int = 0
    private let onCompletion: (AccountCreationResult) -> Void
    private var previousDelegate: UINavigationControllerDelegate?
    private var firstScreenController: UIViewController?

    public init(
        navigationController: UINavigationController,
        configuration: FlowConfiguration,
        onCompletion: @escaping (AccountCreationResult) -> Void
    ) {
        self.navigationController = navigationController
        // Sort screens by orderId to ensure correct order
        self.configuration = configuration.sorted { $0.orderId < $1.orderId }
        self.onCompletion = onCompletion
        super.init()

        // Save the previous delegate and set ourselves as delegate
        self.previousDelegate = navigationController.delegate
        navigationController.delegate = self
    }

    public func start() {
        guard let config = configuration, !config.isEmpty else {
            print("❌ No configuration or screens available")
            return
        }

        currentScreenIndex = 0
        showScreen(at: currentScreenIndex)

        // Show navigation bar after pushing the view controller, with animation
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    private func showScreen(at index: Int) {
        guard let config = configuration, index < config.count else {
            print("❌ Invalid screen index: \(index)")
            return
        }

        let screen = config[index]
        print("📱 Showing screen: \(screen.title) (index: \(index))")

        let hostingController: UIHostingController<AnyView>

        switch screen.id {
        case "create_account":
            let view = CreateAccountView(
                screenConfig: screen,
                onContinue: { [weak self] in
                    self?.navigateToNext()
                }
            )
            hostingController = UIHostingController(rootView: AnyView(view))

        case "personal_details_1", "personal_details_2":
            let view = PersonalDetailsView(
                screenConfig: screen,
                onContinue: { [weak self] in
                    self?.navigateToNext()
                }
            )
            hostingController = UIHostingController(rootView: AnyView(view))

        default:
            let view = PersonalDetailsView(
                screenConfig: screen,
                onContinue: { [weak self] in
                    self?.navigateToNext()
                }
            )
            hostingController = UIHostingController(rootView: AnyView(view))
        }

        hostingController.title = screen.title
        hostingController.navigationItem.largeTitleDisplayMode = .never

        // Store reference to first screen for delegate detection
        if index == 0 {
            firstScreenController = hostingController
        }

        navigationController?.pushViewController(hostingController, animated: true)
    }

    // MARK: - UINavigationControllerDelegate

    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        // Check if the first screen was popped (user went back to Welcome)
        if let firstScreen = firstScreenController,
           !navigationController.viewControllers.contains(firstScreen) {
            print("🔙 Back to Welcome - first screen was popped")
            cleanupAndComplete(with: .cancelled)
        }
    }

    // MARK: - Navigation

    private func navigateToNext() {
        guard let config = configuration else { return }

        print("🚀 navigateToNext called")
        print("   Current index: \(currentScreenIndex)")
        print("   Total screens: \(config.count)")

        if currentScreenIndex < config.count - 1 {
            currentScreenIndex += 1
            showScreen(at: currentScreenIndex)
        } else {
            // Flow completed
            print("   ✅ Flow completed!")
            cleanupAndComplete(with: .completed([:]))
        }
    }

    private func cleanupAndComplete(with result: AccountCreationResult) {
        // Restore previous delegate
        navigationController?.delegate = previousDelegate

        // Call completion
        onCompletion(result)
    }
}
