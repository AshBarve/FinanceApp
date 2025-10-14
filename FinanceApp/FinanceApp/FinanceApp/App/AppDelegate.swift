import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Create window
        window = UIWindow(frame: UIScreen.main.bounds)

        // Create navigation controller with WelcomeViewController as root
        let welcomeViewController = WelcomeViewController()
        let navigationController = UINavigationController(rootViewController: welcomeViewController)

        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]

        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.tintColor = UIColor.appPrimary

        // Set as root view controller
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
