import SwiftUI

struct ModuleListView: View {
    @EnvironmentObject var viewModel: StudyTrackerViewModel

    var body: some View {
        List {
            ForEach(viewModel.sortedSemesters, id: \.self) { semester in
                Section("Semester \(semester)") {
                    ForEach(viewModel.modulesGroupedBySemester[semester] ?? []) { module in
                        NavigationLink(destination: ModuleDetailView(module: module)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(module.name)
                                    .font(.headline)

                                HStack {
                                    Text("\(module.ects) ECTS")
                                    Text("•")
                                    Text(module.examType)
                                }
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                                Text(viewModel.progressForModule(module).status.rawValue)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(statusColor(for: viewModel.progressForModule(module).status).opacity(0.2))
                                    .clipShape(Capsule())
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .navigationTitle("Module")
    }

    private func statusColor(for status: ModuleStatus) -> Color {
        switch status {
        case .notStarted:
            return .gray
        case .inProgress:
            return .orange
        case .completed:
            return .green
        }
    }
}

#Preview {
    ModuleListView()
        .environmentObject(StudyTrackerViewModel())
}
