import Foundation

public struct ScreenModel: Codable, Identifiable, Hashable {
    public let id: String
    public let orderId: Int
    public let title: String
    public let subtitle: String?
    public let headerTitle: String?
    public let showBackButton: Bool
    public let progress: ProgressModel?
    public let fields: [FieldModel]
    public let actions: [ActionModel]

    enum CodingKeys: String, CodingKey {
        case id, orderId, title, subtitle, headerTitle, showBackButton, progress, fields, actions
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: ScreenModel, rhs: ScreenModel) -> Bool {
        lhs.id == rhs.id
    }
}

public struct ProgressModel: Codable {
    public let currentStep: Int
    public let totalSteps: Int
}

public struct ActionModel: Codable, Identifiable {
    public let id: String
    public let type: String
    public let title: String
    public let action: String

    enum CodingKeys: String, CodingKey {
        case id, type, title, action
    }
}
