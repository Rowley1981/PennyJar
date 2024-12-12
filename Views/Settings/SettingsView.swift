import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Section("App Settings") {
                Text("Settings coming soon...")
                    .foregroundStyle(.secondary)
            }
            
            Section("About") {
                LabeledContent("Version", value: Bundle.main.appVersion)
            }
        }
        .navigationTitle("Settings")
    }
}

private extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
} 