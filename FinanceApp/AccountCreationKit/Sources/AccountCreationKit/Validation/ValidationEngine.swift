import Foundation

public class ValidationEngine {
    public init() {}

    public func validate(value: String, rules: [ValidationRule]) -> ValidationResult {
        for rule in rules {
            let result = validateRule(value: value, rule: rule)
            if !result.isValid {
                return result
            }
        }
        return ValidationResult(isValid: true, errorMessage: nil)
    }

    public func validateDate(value: Date?, rules: [ValidationRule]) -> ValidationResult {
        guard let date = value else {
            if rules.contains(where: { $0.type == ValidationType.required }) {
                return ValidationResult(isValid: false, errorMessage: rules.first(where: { $0.type == ValidationType.required })?.message ?? "This field is required")
            }
            return ValidationResult(isValid: true, errorMessage: nil)
        }

        for rule in rules {
            if rule.type == ValidationType.minAge, let minAge = rule.value {
                let calendar = Calendar.current
                let ageComponents = calendar.dateComponents([.year], from: date, to: Date())
                if let age = ageComponents.year, age < minAge {
                    return ValidationResult(isValid: false, errorMessage: rule.message)
                }
            }
        }

        return ValidationResult(isValid: true, errorMessage: nil)
    }

    private func validateRule(value: String, rule: ValidationRule) -> ValidationResult {
        switch rule.type {
        case ValidationType.required:
            return ValidationResult(
                isValid: !value.trimmingCharacters(in: .whitespaces).isEmpty,
                errorMessage: value.isEmpty ? rule.message : nil
            )

        case ValidationType.email:
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return ValidationResult(
                isValid: emailPredicate.evaluate(with: value),
                errorMessage: emailPredicate.evaluate(with: value) ? nil : rule.message
            )

        case ValidationType.phone:
            let phoneRegex = "^[0-9]{10,15}$"
            let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return ValidationResult(
                isValid: phonePredicate.evaluate(with: value),
                errorMessage: phonePredicate.evaluate(with: value) ? nil : rule.message
            )

        case ValidationType.minLength:
            guard let minLength = rule.value else {
                return ValidationResult(isValid: true, errorMessage: nil)
            }
            return ValidationResult(
                isValid: value.count >= minLength,
                errorMessage: value.count >= minLength ? nil : rule.message
            )

        case ValidationType.maxLength:
            guard let maxLength = rule.value else {
                return ValidationResult(isValid: true, errorMessage: nil)
            }
            return ValidationResult(
                isValid: value.count <= maxLength,
                errorMessage: value.count <= maxLength ? nil : rule.message
            )

        case ValidationType.numeric:
            let isNumeric = Int(value) != nil
            return ValidationResult(
                isValid: value.isEmpty || isNumeric,
                errorMessage: isNumeric || value.isEmpty ? nil : rule.message
            )

        default:
            return ValidationResult(isValid: true, errorMessage: nil)
        }
    }
}

public struct ValidationResult {
    public let isValid: Bool
    public let errorMessage: String?

    public init(isValid: Bool, errorMessage: String?) {
        self.isValid = isValid
        self.errorMessage = errorMessage
    }
}
