import Foundation
import Combine

public class CreateAccountViewModel: BaseFormViewModel {
    @Published public var countryCodes: [(code: String, name: String)] = []

    private let countryCodesEndpoint = "/api/v1/country-codes"
    private let validateNationalIdEndpoint = "/api/v1/validate-national-id"

    public override init() {
        super.init()
    }

    public override func onScreenAppear() {
        super.onScreenAppear()
        loadCountryCodes()
    }

    public override func onContinueTapped() {
        super.onContinueTapped()
        print("CreateAccount - Continue tapped")
        print("National ID: \(getStringValue(for: "national_id"))")
        print("Mobile Number: \(getStringValue(for: "mobile_number"))")
        print("Email: \(getStringValue(for: "email"))")
    }

    private func loadCountryCodes() {
        // TODO: Replace with actual API call
        // For now, using mock data
        countryCodes = [
            ("+1", "United States"),
            ("+44", "United Kingdom"),
            ("+91", "India")
        ]
    }

    public func validateNationalId() async -> Bool {
        // TODO: Implement API call to validate national ID
        let nationalId = getStringValue(for: "national_id")
        print("Validating national ID: \(nationalId)")
        return true
    }
}
