import UIKit
import AccountCreationKit

class WelcomeViewController: UIViewController {
    private let viewModel = WelcomeViewModel()
    private var accountCreationCoordinator: AccountCreationCoordinator?

    private let logoImageView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.appPrimary
        view.layer.cornerRadius = 40
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome"
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Get started with your account"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor.appTextSecondary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Account", for: .normal)
        button.titleLabel?.font = UIFont.appButton
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.appPrimary
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createAccountTapped), for: .touchUpInside)
        return button
    }()

    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = UIFont.appButton
        button.setTitleColor(UIColor.appPrimary, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.appBorder.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide navigation bar on Welcome screen
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(createAccountButton)
        view.addSubview(signInButton)

        NSLayoutConstraint.activate([
            // Logo
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),

            // Title
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),

            // Subtitle
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),

            // Create Account Button
            createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            createAccountButton.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -16),
            createAccountButton.heightAnchor.constraint(equalToConstant: 56),

            // Sign In Button
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            signInButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }

    @objc private func createAccountTapped() {
        viewModel.handleCreateAccount()
        navigateToAccountCreation()
    }

    @objc private func signInTapped() {
        viewModel.handleSignIn()
        // TODO: Navigate to Sign In flow
    }

    private func navigateToAccountCreation() {
        print("🚀 navigateToAccountCreation called")

        // Load JSON configuration
        print("📦 Looking for JSON in bundle...")
        guard let jsonURL = Bundle.main.url(forResource: "account_creation_flow", withExtension: "json") else {
            print("❌ Failed to find JSON file in bundle")
            print("Bundle path: \(Bundle.main.bundlePath)")
            return
        }

        print("✅ Found JSON at: \(jsonURL)")

        guard let jsonData = try? Data(contentsOf: jsonURL) else {
            print("❌ Failed to load JSON data from file")
            return
        }

        print("✅ Loaded JSON data, size: \(jsonData.count) bytes")

        // Parse configuration
        let parser = FlowConfigParser()
        do {
            let config = try parser.parse(from: jsonData)
            print("✅ Parsed configuration successfully, screens: \(config.count)")

            // Start account creation flow using UIKit navigation
            guard let navController = navigationController else {
                print("❌ No navigation controller available")
                return
            }

            // Store coordinator to prevent deallocation
            accountCreationCoordinator = AccountCreationCoordinator(
                navigationController: navController,
                configuration: config,
                onCompletion: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .completed(let data):
                        print("Account creation completed with data: \(data)")
                        self.navigationController?.popToViewController(self, animated: true)
                        self.accountCreationCoordinator = nil
                    case .cancelled:
                        print("Account creation cancelled")
                        self.navigationController?.popToViewController(self, animated: true)
                        self.accountCreationCoordinator = nil
                    }
                }
            )

            accountCreationCoordinator?.start()

            print("✅ Account creation flow started")

        } catch {
            print("❌ Failed to parse JSON configuration: \(error)")
            return
        }
    }
}
