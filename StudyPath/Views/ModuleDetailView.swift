import SwiftUI

struct ModuleDetailView: View {
    let module: StudyModule
    @EnvironmentObject var viewModel: StudyTrackerViewModel

    var body: some View {
        let progress = viewModel.progressForModule(module)

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(module.name)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Code: \(module.code)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                infoCard(progress: progress)

                if progress.status == .inProgress {
                    planningCard
                }

                statusSection(module: module, currentStatus: progress.status)

                Spacer(minLength: 20)
            }
            .padding()
        }
        .navigationTitle("Moduldetails")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }

    @ViewBuilder
    private func infoCard(progress: ModuleProgress) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            detailRow(title: "Semester", value: "\(module.semester)")
            detailRow(title: "ECTS", value: "\(module.ects)")
            detailRow(title: "Prüfungsform", value: module.examType)
            detailRow(title: "Status", value: progress.status.rawValue)

            if let startDate = progress.startDate {
                detailRow(title: "Gestartet am", value: formattedDate(startDate))
            }

            if let completionDate = progress.completionDate {
                detailRow(title: "Abgeschlossen am", value: formattedDate(completionDate))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private var planningCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Zeitplanung")
                .font(.headline)

            if let targetDate = viewModel.targetDate(for: module) {
                detailRow(title: "Empfohlen bis", value: formattedDate(targetDate))
            }

            if let daysRemaining = viewModel.daysRemaining(for: module) {
                detailRow(title: "Verbleibend", value: remainingText(daysRemaining))
            }

            if let scheduleStatus = viewModel.scheduleStatus(for: module) {
                HStack {
                    Text("Zeitstatus")
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text(scheduleStatus.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(scheduleStatus.color.opacity(0.15))
                        .foregroundStyle(scheduleStatus.color)
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private func statusSection(module: StudyModule, currentStatus: ModuleStatus) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Status ändern")
                .font(.headline)

            statusButton(
                title: "Nicht begonnen",
                color: .gray,
                isSelected: currentStatus == .notStarted,
                isDisabled: currentStatus == .notStarted
            ) {
                viewModel.updateStatus(for: module, to: .notStarted)
            }

            statusButton(
                title: "Als gestartet markieren",
                color: .orange,
                isSelected: currentStatus == .inProgress,
                isDisabled: currentStatus == .inProgress
            ) {
                viewModel.updateStatus(for: module, to: .inProgress)
            }

            statusButton(
                title: "Als abgeschlossen markieren",
                color: .green,
                isSelected: currentStatus == .completed,
                isDisabled: currentStatus == .completed
            ) {
                viewModel.updateStatus(for: module, to: .completed)
            }
        }
    }

    private func statusButton(
        title: String,
        color: Color,
        isSelected: Bool,
        isDisabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .fontWeight(.semibold)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.body)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? color.opacity(0.2) : color.opacity(0.12))
            .foregroundColor(isDisabled ? color.opacity(0.6) : color)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.75 : 1.0)
    }

    @ViewBuilder
    private func detailRow(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .multilineTextAlignment(.trailing)
        }
    }

    private func remainingText(_ days: Int) -> String {
        if days < 0 {
            return "\(abs(days)) Tage überfällig"
        } else if days == 1 {
            return "1 Tag"
        } else {
            return "\(days) Tage"
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "de_DE")
        return formatter.string(from: date)
    }
}
