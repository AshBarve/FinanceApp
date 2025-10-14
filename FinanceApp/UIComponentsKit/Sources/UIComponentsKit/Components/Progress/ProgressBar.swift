import SwiftUI

public struct ProgressBar: View {
    let currentStep: Int
    let totalSteps: Int

    public init(currentStep: Int, totalSteps: Int) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 4)
                    .cornerRadius(2)

                // Progress fill
                Rectangle()
                    .fill(Color.appPrimary)
                    .frame(width: progressWidth(totalWidth: geometry.size.width), height: 4)
                    .cornerRadius(2)
            }
        }
        .frame(height: 4)
    }

    private func progressWidth(totalWidth: CGFloat) -> CGFloat {
        let progress = CGFloat(currentStep) / CGFloat(totalSteps)
        return totalWidth * progress
    }
}
