import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var viewModel: StudyTrackerViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Timeline")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Hier siehst du den zeitlichen Verlauf deiner gestarteten und abgeschlossenen Module.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if timelineEntries.isEmpty {
                    emptyStateView
                } else {
                    VStack(spacing: 16) {
                        ForEach(timelineEntries) { entry in
                            timelineCard(entry: entry)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    private var timelineEntries: [TimelineEntry] {
        var entries: [TimelineEntry] = []

        for module in viewModel.modules {
            let progress = viewModel.progressForModule(module)

            if let startDate = progress.startDate {
                entries.append(
                    TimelineEntry(
                        moduleName: module.name,
                        moduleCode: module.code,
                        date: startDate,
                        eventType: .started
                    )
                )
            }

            if let completionDate = progress.completionDate {
                entries.append(
                    TimelineEntry(
                        moduleName: module.name,
                        moduleCode: module.code,
                        date: completionDate,
                        eventType: .completed
                    )
                )
            }
        }

        return entries.sorted { $0.date > $1.date }
    }

    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "calendar")
                .font(.system(size: 36))
                .foregroundStyle(.secondary)

            Text("Noch keine Timeline-Einträge")
                .font(.headline)

            Text("Sobald du Module startest oder abschließt, erscheinen sie hier im zeitlichen Verlauf.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .padding(.horizontal, 20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func timelineCard(entry: TimelineEntry) -> some View {
        let module = viewModel.modules.first { $0.code == entry.moduleCode }

        return HStack(alignment: .top, spacing: 14) {
            VStack(spacing: 0) {
                Circle()
                    .fill(entry.eventType.color)
                    .frame(width: 14, height: 14)

                Rectangle()
                    .fill(Color.gray.opacity(0.25))
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
            }
            .padding(.top, 6)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(entry.eventType.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(entry.eventType.color.opacity(0.15))
                        .foregroundStyle(entry.eventType.color)
                        .clipShape(Capsule())

                    Spacer()

                    Text(formattedDate(entry.date))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text(entry.moduleName)
                    .font(.headline)

                Text(entry.moduleCode)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if entry.eventType == .started, let module {
                    planningInfo(for: module)
                }
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }

    @ViewBuilder
    private func planningInfo(for module: StudyModule) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let targetDate = viewModel.targetDate(for: module) {
                infoRow(title: "Empfohlen bis", value: formattedDate(targetDate))
            }

            if let daysRemaining = viewModel.daysRemaining(for: module) {
                infoRow(title: "Verbleibend", value: remainingText(daysRemaining))
            }

            if let scheduleStatus = viewModel.scheduleStatus(for: module) {
                HStack {
                    Text("Zeitstatus")
                        .font(.caption)
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
        .padding(.top, 4)
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "de_DE")
        return formatter.string(from: date)
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
}
