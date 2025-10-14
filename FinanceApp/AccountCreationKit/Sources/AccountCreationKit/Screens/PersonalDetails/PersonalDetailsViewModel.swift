import Foundation
import Combine

public class PersonalDetailsViewModel: BaseFormViewModel {
    public override init() {
        super.init()
    }

    public override func onScreenAppear() {
        super.onScreenAppear()

        // Fetch dynamic options from API
        Task {
            await fetchDynamicOptions()
        }
    }

    @MainActor
    private func fetchDynamicOptions() async {
        isLoadingOptions = true

        do {
            // Fetch marital status options
            print("📡 Fetching marital status options...")
            let maritalOptions = try await AccountCreationService.shared.fetchMaritalStatusOptions()
            updateFieldOptions(fieldId: "marital_status", options: maritalOptions)

            // Fetch education level options
            print("📡 Fetching education level options...")
            let educationOptions = try await AccountCreationService.shared.fetchEducationLevels()
            updateFieldOptions(fieldId: "education_level", options: educationOptions)

        } catch {
            print("❌ Error fetching options: \(error)")
        }

        isLoadingOptions = false
    }

    public override func onContinueTapped() {
        super.onContinueTapped()
        print("PersonalDetails - Continue tapped")
        print("Full Name: \(getStringValue(for: "full_name"))")
        print("Date of Birth: \(getDateValue(for: "date_of_birth") ?? Date())")
        print("Nationality: \(getStringValue(for: "nationality"))")
        print("Place of Birth: \(getStringValue(for: "place_of_birth"))")
        print("Marital Status: \(getStringValue(for: "marital_status"))")
        print("Number of Dependents: \(getStringValue(for: "number_of_dependents"))")
        print("Education Level: \(getStringValue(for: "education_level"))")
        print("Are you ultimate beneficial owner: \(getStringValue(for: "are_you_owner"))")
        print("Dual Nationality: \(getStringValue(for: "dual_nationality"))")
        if getStringValue(for: "dual_nationality") == "yes" {
            print("  Dual Nationality Country: \(getStringValue(for: "dual_nationality_country"))")
        }
        print("Immigrant Visa Status: \(getStringValue(for: "immigrant_visa_status"))")
        if getStringValue(for: "immigrant_visa_status") == "yes" {
            print("  Immigrant Visa Country: \(getStringValue(for: "immigrant_visa_country"))")
            if getStringValue(for: "marital_status") == "married" {
                print("  Tax Identification Number: \(getStringValue(for: "tax_identification_number"))")
            }
        }
        print("Residence Type: \(getStringValue(for: "residence_type"))")
    }
}
