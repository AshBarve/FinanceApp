import SwiftUI
import UIComponentsKit // Still needed for PickerOption type

public struct DynamicFormRenderer<ViewModel: BaseFormViewModel>: View {
    let screenConfig: ScreenModel
    @ObservedObject var viewModel: ViewModel
    let onContinue: () -> Void

    public init(
        screenConfig: ScreenModel,
        viewModel: ViewModel,
        onContinue: @escaping () -> Void
    ) {
        self.screenConfig = screenConfig
        self.viewModel = viewModel
        self.onContinue = onContinue
    }

    public var body: some View {
        // Use viewModel.screenConfig instead of parameter to pick up dynamic updates
        let currentConfig = viewModel.screenConfig ?? screenConfig

        return VStack(spacing: 0) {
            // Progress bar
            if let progress = currentConfig.progress {
                ProgressBar(currentStep: progress.currentStep, totalSteps: progress.totalSteps)
                    .padding(.horizontal, DesignTokens.Spacing.large)
                    .padding(.top, DesignTokens.Spacing.small)
                    .padding(.bottom, DesignTokens.Spacing.large)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.medium) {
                    // Screen title
                    Text(currentConfig.title)
                        .font(.system(size: 28, weight: .regular))
                        .foregroundColor(.appTextPrimary)

                    // Screen subtitle
                    if let subtitle = currentConfig.subtitle {
                        Text(subtitle)
                            .font(.system(size: 15))
                            .foregroundColor(.appTextSecondary)
                            .padding(.bottom, DesignTokens.Spacing.small)
                    }

                    // Fields - sorted by orderId to ensure correct order
                    // Use currentConfig.fields to pick up dynamic option updates
                    ForEach(currentConfig.fields.sorted { $0.orderId < $1.orderId }) { field in
                        if shouldShowField(field) {
                            renderField(field)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .top).combined(with: .opacity),
                                    removal: .move(edge: .top).combined(with: .opacity)
                                ))
                                .id(field.id)
                        }
                    }

                    Spacer(minLength: DesignTokens.Spacing.xlarge)

                    // Actions
                    ForEach(currentConfig.actions) { action in
                        renderAction(action)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.fieldValuesVersion)
                .padding(.horizontal, DesignTokens.Spacing.large)
                .padding(.top, DesignTokens.Spacing.medium)
            }
        }
        .background(Color.appSurface)
        .navigationTitle(currentConfig.headerTitle ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("📱 Screen appeared: \(currentConfig.title)")
            viewModel.screenConfig = screenConfig
            viewModel.onScreenAppear()
        }
    }

    private func shouldShowField(_ field: FieldModel) -> Bool {
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
            let arrayValue = viewModel.getArrayValue(for: condition.fieldId)
            return arrayValue.contains(condition.value)
        } else {
            // Default "equals" operator
            let fieldValue = viewModel.getStringValue(for: condition.fieldId)
            return fieldValue == condition.value
        }
    }

    @ViewBuilder
    private func renderField(_ field: FieldModel) -> some View {
        switch field.type {
        case FieldType.label:
            ACKSectionLabel(
                text: field.text ?? field.label,
                style: field.style ?? "section"
            )

        case FieldType.textField:
            ACKTextField(
                label: field.label,
                placeholder: field.placeholder ?? "",
                text: Binding(
                    get: { viewModel.getStringValue(for: field.id) },
                    set: { viewModel.setValue($0, for: field.id) }
                ),
                keyboardType: keyboardType(for: field.keyboard),
                isDisabled: field.isDisabled ?? false,
                inputFilter: field.inputFilter,
                errorMessage: viewModel.fieldErrors[field.id] ?? nil,
                maxLength: field.maxLength,
                onBlur: {
                    viewModel.markFieldAsTouched(field.id)
                }
            )

        case FieldType.phoneField:
            ACKPhoneField(
                label: field.label,
                placeholder: field.placeholder ?? "",
                countryCode: Binding(
                    get: { viewModel.getStringValue(for: "\(field.id)_country_code").isEmpty ? (field.defaultCountryCode ?? "+1") : viewModel.getStringValue(for: "\(field.id)_country_code") },
                    set: { viewModel.setValue($0, for: "\(field.id)_country_code") }
                ),
                phoneNumber: Binding(
                    get: { viewModel.getStringValue(for: field.id) },
                    set: { viewModel.setValue($0, for: field.id) }
                )
            )

        case FieldType.datePicker:
            ACKDateField(
                label: field.label,
                placeholder: field.placeholder ?? "",
                date: Binding(
                    get: { viewModel.getDateValue(for: field.id) },
                    set: { viewModel.setValue($0 as Any, for: field.id) }
                ),
                dateFormat: field.dateFormat ?? "MM/dd/yyyy",
                isDisabled: field.isDisabled ?? false
            )

        case FieldType.dropdown:
            if field.isMultiSelect == true {
                ACKMultiPicker(
                    label: field.label,
                    placeholder: field.placeholder ?? "Select options",
                    selectedOptions: Binding(
                        get: { viewModel.getArrayValue(for: field.id) },
                        set: { viewModel.setValue($0, for: field.id) }
                    ),
                    options: field.options?.map { PickerOption(id: $0.id, label: $0.label) } ?? [],
                    isDisabled: field.isDisabled ?? false
                )
            } else {
                ACKPicker(
                    label: field.label,
                    placeholder: field.placeholder ?? "Select an option",
                    selectedOption: Binding(
                        get: {
                            let value = viewModel.getStringValue(for: field.id)
                            return value.isEmpty ? nil : value
                        },
                        set: { viewModel.setValue($0 ?? "", for: field.id) }
                    ),
                    options: field.options?.map { PickerOption(id: $0.id, label: $0.label) } ?? [],
                    isDisabled: field.isDisabled ?? false
                )
            }

        case FieldType.radioGroup:
            ACKRadioGroup(
                label: field.label,
                options: field.options?.map { PickerOption(id: $0.id, label: $0.label) } ?? [],
                selectedOption: Binding(
                    get: {
                        let value = viewModel.getStringValue(for: field.id)
                        return value.isEmpty ? nil : value
                    },
                    set: { viewModel.setValue($0 ?? "", for: field.id) }
                )
            )

        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private func renderAction(_ action: ActionModel) -> some View {
        if action.type == "primary_button" {
            ACKButton(
                title: action.title,
                isEnabled: viewModel.isFormValid,
                action: {
                    print("🔘 Continue button tapped")
                    print("   Form valid: \(viewModel.isFormValid)")

                    if viewModel.validateAllFields() {
                        print("   ✅ Validation passed")
                        viewModel.onContinueTapped()
                        onContinue()
                    } else {
                        print("   ❌ Validation failed")
                        print("   Errors: \(viewModel.fieldErrors)")
                    }
                }
            )
        }
    }

    private func keyboardType(for keyboard: String?) -> UIKeyboardType {
        switch keyboard {
        case "number_pad":
            return .numberPad
        case "email":
            return .emailAddress
        case "phone":
            return .phonePad
        default:
            return .default
        }
    }
}
