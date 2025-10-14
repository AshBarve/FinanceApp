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
    private var screenViewModels: [String: BaseFormViewModel] = [:] // Store ViewModels for data collection

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
            let viewModel = CreateAccountViewModel()
            screenViewModels[screen.id] = viewModel
            let view = CreateAccountView(
                screenConfig: screen,
                viewModel: viewModel,
                onContinue: { [weak self] in
                    self?.navigateToNext()
                }
            )
            hostingController = UIHostingController(rootView: AnyView(view))

        case "personal_details_1", "personal_details_2":
            let viewModel = PersonalDetailsViewModel()
            screenViewModels[screen.id] = viewModel
            let view = PersonalDetailsView(
                screenConfig: screen,
                viewModel: viewModel,
                onContinue: { [weak self] in
                    self?.navigateToNext()
                }
            )
            hostingController = UIHostingController(rootView: AnyView(view))

        case "financial_details":
            let viewModel = FinancialDetailsViewModel()
            screenViewModels[screen.id] = viewModel
            let view = FinancialDetailsView(
                screenConfig: screen,
                viewModel: viewModel,
                onContinue: { [weak self] in
                    self?.navigateToNext()
                }
            )
            hostingController = UIHostingController(rootView: AnyView(view))

        default:
            // Fallback to PersonalDetailsView for unknown screens
            let viewModel = PersonalDetailsViewModel()
            screenViewModels[screen.id] = viewModel
            let view = PersonalDetailsView(
                screenConfig: screen,
                viewModel: viewModel,
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
            // Flow completed - submit all data
            print("   ✅ Flow completed!")
            Task {
                await submitAccountCreation()
            }
        }
    }

    // MARK: - Final Submission

    private func submitAccountCreation() async {
        print("📦 Collecting all form data...")

        // Collect all field values from all screens
        var allData: [String: Any] = [:]

        for (screenId, viewModel) in screenViewModels {
            // Convert Date objects to strings for JSON serialization
            let serializedValues = serializeFieldValues(viewModel.fieldValues)
            allData[screenId] = serializedValues
            print("   • Collected data from: \(screenId)")
        }

        do {
            print("📡 Submitting to API...")
            let success = try await AccountCreationService.shared.submitAccountCreation(data: allData)

            await MainActor.run {
                if success {
                    print("✅ Submission successful!")
                    cleanupAndComplete(with: .completed(allData))
                } else {
                    print("❌ Submission failed")
                    showError("Account creation failed. Please try again.")
                }
            }
        } catch {
            await MainActor.run {
                print("❌ Submission error: \(error)")
                showError("Network error: \(error.localizedDescription)")
            }
        }
    }

    /// Converts Date objects to ISO8601 strings for JSON serialization
    private func serializeFieldValues(_ fieldValues: [String: Any]) -> [String: Any] {
        var serialized: [String: Any] = [:]
        let dateFormatter = ISO8601DateFormatter()

        for (key, value) in fieldValues {
            if let date = value as? Date {
                // Convert Date to ISO8601 string
                serialized[key] = dateFormatter.string(from: date)
            } else {
                // Keep other values as-is
                serialized[key] = value
            }
        }

        return serialized
    }

    private func showError(_ message: String) {
        guard let navController = navigationController else { return }

        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        navController.present(alert, animated: true)
    }

    private func cleanupAndComplete(with result: AccountCreationResult) {
        // Restore previous delegate
        navigationController?.delegate = previousDelegate

        // Call completion
        onCompletion(result)
    }
}
