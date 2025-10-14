import Foundation

public struct FlowConfiguration: Codable {
    public let flowId: String
    public let version: String
    public var screens: [ScreenModel]  // Changed to var to allow sorting

    enum CodingKeys: String, CodingKey {
        case flowId, version, screens
    }
}
