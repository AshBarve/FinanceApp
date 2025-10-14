import Foundation

public enum FlowConfigParserError: Error {
    case invalidJSON
    case decodingError(Error)
}

public class FlowConfigParser {
    public init() {}

    public func parse(from jsonData: Data) throws -> FlowConfiguration {
        let decoder = JSONDecoder()
        do {
            let config = try decoder.decode(FlowConfiguration.self, from: jsonData)
            return config
        } catch {
            throw FlowConfigParserError.decodingError(error)
        }
    }

    public func parse(from jsonString: String) throws -> FlowConfiguration {
        guard let data = jsonString.data(using: .utf8) else {
            throw FlowConfigParserError.invalidJSON
        }
        return try parse(from: data)
    }

    public func loadFromFile(named filename: String, bundle: Bundle = .main) throws -> FlowConfiguration {
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            throw FlowConfigParserError.invalidJSON
        }
        let data = try Data(contentsOf: url)
        return try parse(from: data)
    }
}
