import SwiftUI

struct ModuleRowView: View {
    let module: StudyModule
    @EnvironmentObject var viewModel: StudyTrackerViewModel

    var body: some View {
        let progress = viewModel.progressForModule(module)

        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(module.name)
                        .font(.headline)

                    Text("\(module.ects) ECTS  •  \(module.examType)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Text(progress.status.rawValue)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(statusColor(progress.status).opacity(0.15))
                .foregroundStyle(statusColor(progress.status))
                .clipShape(Capsule())

            Divider()
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func statusColor(_ status: ModuleStatus) -> Color {
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
