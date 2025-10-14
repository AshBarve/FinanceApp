import Foundation
import Combine

public class FinancialDetailsViewModel: BaseFormViewModel {
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
            // Fetch employment sector options
            print("📡 Fetching employment sector options...")
            let employmentSectorOptions = try await AccountCreationService.shared.fetchEmploymentSectors()
            updateFieldOptions(fieldId: "employment_sector", options: employmentSectorOptions)

        } catch {
            print("❌ Error fetching options: \(error)")
        }

        isLoadingOptions = false
    }

    public override func onContinueTapped() {
        super.onContinueTapped()
        print("FinancialDetails - Continue tapped")
        print("Approximate Annual Income: \(getStringValue(for: "approximate_annual_income"))")
        print("Source of Income: \(getArrayValue(for: "source_of_income"))")

        let sourceOfIncome = getArrayValue(for: "source_of_income")

        if sourceOfIncome.contains("employment") {
            print("  Employment Status: \(getStringValue(for: "employment_status"))")
            print("  Employment Sector: \(getStringValue(for: "employment_sector"))")
            print("  Employer Name: \(getStringValue(for: "employer_name"))")
            print("  Job Title: \(getStringValue(for: "job_title"))")
            print("  Years of Service: \(getStringValue(for: "years_of_service"))")
            print("  Employer Address: \(getStringValue(for: "employer_mailing_address"))")
            print("  Employer Phone: \(getStringValue(for: "employer_phone_number"))")
        }

        if sourceOfIncome.contains("investment_assets") {
            print("  Investment Asset Types: \(getArrayValue(for: "investment_asset_types"))")
        }

        if sourceOfIncome.contains("income_from_trading_activities") {
            print("  Trading Entity Name: \(getStringValue(for: "trading_entity_name"))")
            print("  Trading Business Activity: \(getStringValue(for: "trading_business_activity"))")
        }

        if sourceOfIncome.contains("income_from_skilled_activities") {
            print("  Skilled Activity: \(getStringValue(for: "skilled_activity"))")
        }

        if sourceOfIncome.contains("family_support") {
            print("  Family Relationship: \(getStringValue(for: "family_relationship"))")
        }

        print("Approximate Net Worth: \(getStringValue(for: "approximate_net_worth"))")
        print("Source of Wealth: \(getStringValue(for: "source_of_wealth"))")
        print("Worked in Financial Sector: \(getStringValue(for: "worked_in_financial_sector"))")

        if getStringValue(for: "worked_in_financial_sector") == "yes" {
            print("  Years in Financial Sector: \(getStringValue(for: "years_in_financial_sector"))")
        }

        print("Practical Experience: \(getStringValue(for: "practical_experience_financial_sector"))")
    }
}
