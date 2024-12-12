import SwiftUI

struct WelcomeView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Logo and Slogan
            VStack(spacing: 16) {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Theme.mediumBlue)
                
                Text("Penny Jar")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(Theme.textPrimary)
                
                Text("Budget better. Save More.")
                    .font(.title3)
                    .foregroundStyle(Theme.textSecondary)
            }
            
            Spacer()
            
            Button {
                hasCompletedOnboarding = true
            } label: {
                Text("Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(Theme.mediumBlue)
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
} 