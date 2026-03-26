import SwiftUI

struct ModuleDetailView: View {
    let module: StudyModule
    @EnvironmentObject var viewModel: StudyTrackerViewModel

    var body: some View {
        let progress = viewModel.progressForModule(module)

        VStack(alignment: .leading, spacing: 16) {
            Text(module.name)
                .font(.title2)
                .bold()

            Text("Semester: \(module.semester)")
            Text("ECTS: \(module.ects)")
            Text("Prüfungsform: \(module.examType)")
            Text("Status: \(progress.status.rawValue)")

            Divider()

            Button("Als gestartet markieren") {
                viewModel.updateStatus(for: module, to: .inProgress)
            }

            Button("Als abgeschlossen markieren") {
                viewModel.updateStatus(for: module, to: .completed)
            }

            Button("Zurücksetzen") {
                viewModel.updateStatus(for: module, to: .notStarted)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Moduldetails")
    }
}

#Preview {
    ModuleDetailView(
        module: StudyModule(
            id: "test",
            code: "TEST01",
            name: "Testmodul",
            semester: 1,
            ects: 5,
            examType: "Klausur"
        )
    )
    .environmentObject(StudyTrackerViewModel())
}
