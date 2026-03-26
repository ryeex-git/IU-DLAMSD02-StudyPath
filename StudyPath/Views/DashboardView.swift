import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: StudyTrackerViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("StudyPath")
                .font(.largeTitle)
                .bold()

            Text("Fortschritt: \(Int(viewModel.progressPercentage * 100))%")
            Text("Abgeschlossen: \(viewModel.completedModulesCount)")
            Text("Laufend: \(viewModel.inProgressModulesCount)")
            Text("Offen: \(viewModel.notStartedModulesCount)")
            Text("ECTS: \(viewModel.completedECTS) / \(viewModel.totalECTS)")
        }
        .padding()
        .navigationTitle("Dashboard")
    }
}

#Preview {
    DashboardView()
        .environmentObject(StudyTrackerViewModel())
}
