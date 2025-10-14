import Foundation

public struct FieldModel: Codable, Identifiable {
    public let id: String
    public let orderId: Int
    public let type: String
    public let label: String
    public let placeholder: String?
    public let validations: [ValidationRule]?
    public let keyboard: String?
    public let defaultCountryCode: String?
    public let dateFormat: String?
    public let options: [OptionModel]?
    public let isDisabled: Bool?
    public let defaultValue: String?
    public let conditionalVisibility: ConditionalVisibility?
    public let text: String?  // For label field type
    public let style: String? // For label field type (e.g., "section", "subsection")
    public let isMultiSelect: Bool? // For dropdown fields that support multiple selection
    public let inputFilter: String? // Regex pattern for real-time input filtering
    public let maxLength: Int? // Maximum character length (enforced at input level)

    enum CodingKeys: String, CodingKey {
        case id, orderId, type, label, placeholder, validations, keyboard
        case defaultCountryCode, dateFormat, options, isDisabled
        case defaultValue, conditionalVisibility, text, style, isMultiSelect, inputFilter, maxLength
    }
}

public struct ConditionalVisibility: Codable {
    public let conditions: [ConditionRule]
    public let `operator`: String?

    enum CodingKeys: String, CodingKey {
        case conditions
        case `operator` = "operator"
    }
}

public struct ConditionRule: Codable {
    public let fieldId: String
    public let value: String
    public let checkOperator: String? // "equals" (default) or "contains" for multi-select

    enum CodingKeys: String, CodingKey {
        case fieldId, value
        case checkOperator = "operator"
    }
}

public struct OptionModel: Codable, Identifiable {
    public let id: String
    public let label: String
}

public struct ValidationRule: Codable {
    public let type: String
    public let message: String
    public let value: Int?

    enum CodingKeys: String, CodingKey {
        case type, message, value
    }
}
