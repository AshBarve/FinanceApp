import Foundation

public class AccountCreationService {
    public static let shared = AccountCreationService()

    private init() {}

    // MARK: - Mock API Calls

    /// Fetches marital status options from API (MOCK)
    /// Endpoint: GET /api/v1/marital-status
    public func fetchMaritalStatusOptions() async throws -> [OptionModel] {
        print("🌐 [API] Fetching marital status options...")

        // Simulate network delay (0.5 seconds)
        try await Task.sleep(nanoseconds: 500_000_000)

        let mockOptions = [
            OptionModel(id: "married", label: "Married"),
            OptionModel(id: "single", label: "Single"),
            OptionModel(id: "divorced", label: "Divorced"),
            OptionModel(id: "widowed", label: "Widowed")
        ]

        print("✅ [API] Received \(mockOptions.count) marital status options")
        return mockOptions
    }

    /// Fetches education level options from API (MOCK)
    /// Endpoint: GET /api/v1/education-levels
    public func fetchEducationLevels() async throws -> [OptionModel] {
        print("🌐 [API] Fetching education levels...")

        // Simulate network delay (0.5 seconds)
        try await Task.sleep(nanoseconds: 500_000_000)

        let mockOptions = [
            OptionModel(id: "high_school", label: "High School"),
            OptionModel(id: "bachelors", label: "Bachelor's Degree"),
            OptionModel(id: "masters", label: "Master's Degree"),
            OptionModel(id: "doctorate", label: "Doctorate"),
            OptionModel(id: "other", label: "Other")
        ]

        print("✅ [API] Received \(mockOptions.count) education levels")
        return mockOptions
    }

    /// Fetches employment sector options from API (MOCK)
    /// Endpoint: GET /api/v1/employment-sectors
    public func fetchEmploymentSectors() async throws -> [OptionModel] {
        print("🌐 [API] Fetching employment sectors...")

        // Simulate network delay (0.5 seconds)
        try await Task.sleep(nanoseconds: 500_000_000)

        let mockOptions = [
            OptionModel(id: "public_sector", label: "Public sector"),
            OptionModel(id: "private_sector", label: "Private sector"),
            OptionModel(id: "self_employed", label: "Self-employed")
        ]

        print("✅ [API] Received \(mockOptions.count) employment sectors")
        return mockOptions
    }

    /// Submits account creation data to API (MOCK)
    /// Endpoint: POST /api/v1/account/create
    public func submitAccountCreation(data: [String: Any]) async throws -> Bool {
        print("🌐 [API] Submitting account creation data...")

        // Simulate network delay (1 second)
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Pretty print the data
        if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("📤 [API] Account creation payload:")
            print(jsonString)
        }

        print("✅ [API] Account creation submitted successfully")
        return true
    }

    // MARK: - Other Methods (kept for reference)

    public func fetchCountryCodes() async throws -> [(code: String, name: String)] {
        // TODO: Implement actual API call
        // Endpoint: /api/v1/country-codes
        return [
            ("+1", "United States"),
            ("+44", "United Kingdom"),
            ("+91", "India")
        ]
    }

    public func validateAccountNumber(_ accountNumber: String) async throws -> Bool {
        // TODO: Implement actual API call
        // Endpoint: /api/v1/validate-account
        return !accountNumber.isEmpty
    }
}
