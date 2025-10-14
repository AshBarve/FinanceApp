import SwiftUI
import UIKit

public extension Font {
    static let appTitle = Font.system(size: 24, weight: .semibold)
    static let appLabel = Font.system(size: 16, weight: .semibold)
    static let appInput = Font.system(size: 16, weight: .regular)
    static let appButton = Font.system(size: 18, weight: .semibold)
    static let appBody = Font.system(size: 16, weight: .regular)
}

public extension UIFont {
    static let appTitle = UIFont.systemFont(ofSize: 24, weight: .semibold)
    static let appLabel = UIFont.systemFont(ofSize: 16, weight: .semibold)
    static let appInput = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let appButton = UIFont.systemFont(ofSize: 18, weight: .semibold)
    static let appBody = UIFont.systemFont(ofSize: 16, weight: .regular)
}
