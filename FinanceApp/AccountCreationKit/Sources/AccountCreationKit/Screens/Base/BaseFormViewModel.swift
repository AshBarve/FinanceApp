import Foundation
import Combine

open class BaseFormViewModel: ObservableObject {
    @Published public var fieldValues: [String: Any] = [:]
    @Published public var fieldErrors: [String: String?] = [:]
    @Published public var isFormValid: Bool = false
    @Published public var touchedFields: Set<String> = [] // Track which fields have been blurred
    @Published public var fieldValuesVersion: Int = 0 // Track changes for animation

    public let validationEngine = ValidationEngine()
    public var screenConfig: ScreenModel?

    public init() {}

    open func onScreenAppear() {
        // Initialize default values from field configurations
        initializeDefaultValues()
        // Override in subclasses for screen-specific logic
        // Check form validity when screen appears to initialize button state
        checkFormValidity()
    }

    private func initializeDefaultValues() {
        guard let screen = screenConfig else { return }

        for field in screen.fields {
            // Set default value if provided and field is empty
            if let defaultValue = field.defaultValue, fieldValues[field.id] == nil {
                if field.type == FieldType.datePicker {
                    // Parse date from string using the field's date format
                    let dateFormat = field.dateFormat ?? "MM/dd/yyyy"
                    let formatter = DateFormatter()
                    formatter.dateFormat = dateFormat
                    if let date = formatter.date(from: defaultValue) {
                        fieldValues[field.id] = date
                    }
                } else {
                    fieldValues[field.id] = defaultValue
                }
            }
        }
    }

    open func onContinueTapped() {
        // Override in subclasses for screen-specific logic
    }

    public func setValue(_ value: Any, for fieldId: String) {
        fieldValues[fieldId] = value
        fieldValuesVersion += 1 // Increment version to trigger animation
        // Don't mark as touched here - only on blur
        // This way errors only show after user leaves the field
        validateField(fieldId)
        checkFormValidity()
    }

    public func getValue(for fieldId: String) -> Any? {
        return fieldValues[fieldId]
    }

    public func getStringValue(for fieldId: String) -> String {
        return (fieldValues[fieldId] as? String) ?? ""
    }

    public func getDateValue(for fieldId: String) -> Date? {
        return fieldValues[fieldId] as? Date
    }

    public func getArrayValue(for fieldId: String) -> [String] {
        return (fieldValues[fieldId] as? [String]) ?? []
    }

    public func binding(for fieldId: String) -> String {
        return getStringValue(for: fieldId)
    }

    public func markFieldAsTouched(_ fieldId: String) {
        touchedFields.insert(fieldId)
        // Revalidate the field to show errors that should appear on blur
        validateField(fieldId)
    }

    public func validateField(_ fieldId: String) {
        guard let screen = screenConfig,
              let field = screen.fields.first(where: { $0.id == fieldId }),
              let rules = field.validations else {
            fieldErrors[fieldId] = nil
            return
        }

        if field.type == FieldType.datePicker {
            let dateValue = getDateValue(for: fieldId)
            let result = validationEngine.validateDate(value: dateValue, rules: rules)
            fieldErrors[fieldId] = filterErrorForDisplay(result.errorMessage, fieldId: fieldId, rules: rules)
        } else {
            let value = getStringValue(for: fieldId)
            let result = validationEngine.validate(value: value, rules: rules)
            fieldErrors[fieldId] = filterErrorForDisplay(result.errorMessage, fieldId: fieldId, rules: rules)
        }
    }

    private func filterErrorForDisplay(_ errorMessage: String?, fieldId: String, rules: [ValidationRule]) -> String? {
        guard let error = errorMessage else { return nil }

        // Don't show any errors until the field has been touched (interacted with)
        guard touchedFields.contains(fieldId) else { return nil }

        // Once touched, show all errors
        return error
    }

    public func validateAllFields() -> Bool {
        guard let screen = screenConfig else { return false }

        for field in screen.fields {
            // Skip validation for disabled fields
            if field.isDisabled == true {
                continue
            }

            // Only validate if field should be visible
            if shouldFieldBeVisible(field) {
                // Mark all visible fields as touched so all errors (including min_length) are shown
                touchedFields.insert(field.id)
                validateField(field.id)
            }
        }

        return fieldErrors.values.allSatisfy { $0 == nil }
    }

    private func shouldFieldBeVisible(_ field: FieldModel) -> Bool {
        guard let conditionalVisibility = field.conditionalVisibility else {
            return true
        }
        return evaluateConditionalVisibility(conditionalVisibility)
    }

    private func evaluateConditionalVisibility(_ visibility: ConditionalVisibility) -> Bool {
        let conditions = visibility.conditions

        // Handle empty conditions
        guard !conditions.isEmpty else { return true }

        // Single condition or no operator specified - just check the condition
        if conditions.count == 1 || visibility.operator == nil {
            let condition = conditions[0]
            return evaluateCondition(condition)
        }

        // Multiple conditions with operator
        let operatorType = visibility.operator?.uppercased() ?? ConditionalOperator.and

        if operatorType == ConditionalOperator.and {
            // All conditions must match
            return conditions.allSatisfy { condition in
                evaluateCondition(condition)
            }
        } else if operatorType == ConditionalOperator.or {
            // At least one condition must match
            return conditions.contains { condition in
                evaluateCondition(condition)
            }
        }

        // Unknown operator, default to false
        return false
    }

    private func evaluateCondition(_ condition: ConditionRule) -> Bool {
        let checkOperator = condition.checkOperator?.lowercased() ?? CheckOperator.equals

        if checkOperator == CheckOperator.contains {
            // For multi-select fields, check if array contains the value
            let arrayValue = getArrayValue(for: condition.fieldId)
            return arrayValue.contains(condition.value)
        } else {
            // Default "equals" operator
            let fieldValue = getStringValue(for: condition.fieldId)
            return fieldValue == condition.value
        }
    }

    private func checkFormValidity() {
        guard let screen = screenConfig else {
            isFormValid = false
            return
        }

        // Validate all visible, enabled fields
        for field in screen.fields {
            if field.type != FieldType.label && field.isDisabled != true && shouldFieldBeVisible(field) {
                validateField(field.id)
            }
        }

        // Check if there are any validation errors
        let hasErrors = fieldErrors.values.contains { $0 != nil }

        // Check if all required visible fields have values (excluding disabled fields and label fields)
        let requiredFields = screen.fields.filter { field in
            field.type != FieldType.label // Skip label fields
            && (field.validations?.contains(where: { $0.type == ValidationType.required }) ?? false)
            && field.isDisabled != true
            && shouldFieldBeVisible(field)
        }

        let allRequiredFieldsFilled = requiredFields.allSatisfy { field in
            let isFilled: Bool
            if field.type == FieldType.datePicker {
                isFilled = getDateValue(for: field.id) != nil
            } else if field.type == FieldType.dropdown && field.isMultiSelect == true {
                // For multi-select dropdowns, check if array has at least one item
                let arrayValue = getArrayValue(for: field.id)
                isFilled = !arrayValue.isEmpty
            } else {
                // For text fields, single-select dropdowns, and radio groups
                let value = getStringValue(for: field.id)
                isFilled = !value.trimmingCharacters(in: .whitespaces).isEmpty
            }

            print("📋 Field '\(field.id)' (type: \(field.type)) - required: true, filled: \(isFilled)")
            return isFilled
        }

        print("🔍 Form validation: hasErrors=\(hasErrors), allRequiredFieldsFilled=\(allRequiredFieldsFilled), isFormValid=\(!hasErrors && allRequiredFieldsFilled)")
        print("   Required fields count: \(requiredFields.count)")
        print("   Field errors: \(fieldErrors.filter { $0.value != nil })")

        isFormValid = !hasErrors && allRequiredFieldsFilled
    }
}
