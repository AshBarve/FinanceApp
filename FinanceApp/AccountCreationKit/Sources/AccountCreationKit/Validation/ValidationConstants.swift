import Foundation

/// Constants for validation types used throughout the validation engine
public struct ValidationType {
    /// Validates that a field is not empty
    public static let required = "required"

    /// Validates that a field contains a valid email address
    public static let email = "email"

    /// Validates that a field contains a valid phone number (10-15 digits)
    public static let phone = "phone"

    /// Validates that a field meets a minimum character length
    public static let minLength = "min_length"

    /// Validates that a field does not exceed a maximum character length
    public static let maxLength = "max_length"

    /// Validates that a field contains only numeric characters
    public static let numeric = "numeric"

    /// Validates that a date field meets a minimum age requirement
    public static let minAge = "min_age"

    private init() {} // Prevent instantiation
}

/// Constants for field types used in form configuration
public struct FieldType {
    /// Label field for displaying text (section headers, etc.)
    public static let label = "label"

    /// Standard text input field
    public static let textField = "text_field"

    /// Phone number input field with country code selector
    public static let phoneField = "phone_field"

    /// Date picker field
    public static let datePicker = "date_picker"

    /// Dropdown/picker field (single or multi-select)
    public static let dropdown = "dropdown"

    /// Radio button group field
    public static let radioGroup = "radio_group"

    private init() {} // Prevent instantiation
}

/// Constants for conditional visibility operators
public struct ConditionalOperator {
    /// All conditions must be true (logical AND)
    public static let and = "AND"

    /// At least one condition must be true (logical OR)
    public static let or = "OR"

    private init() {} // Prevent instantiation
}

/// Constants for condition check operators
public struct CheckOperator {
    /// Field value must equal the specified value (default)
    public static let equals = "equals"

    /// Field value (array) must contain the specified value
    public static let contains = "contains"

    private init() {} // Prevent instantiation
}
