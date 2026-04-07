import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: StudyTrackerViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                VStack(alignment: .leading, spacing: 8) {
                    Text("StudyPath")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Behalte deinen Studienfortschritt im Blick.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                progressSection
                summaryCardsSection
                statusCardsSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Fortschritt")
                    .font(.headline)

                Spacer()

                Text("\(Int(viewModel.progressPercentage * 100))%")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
            }

            ProgressView(value: viewModel.progressPercentage)
                .progressViewStyle(.linear)
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .tint(.blue)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var summaryCardsSection: some View {
        HStack(alignment: .top, spacing: 12) {
            ectsSection
            studyGoalSection
        }
    }

    private var ectsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ECTS-Fortschritt")
                .font(.headline)

            HStack(alignment: .lastTextBaseline, spacing: 6) {
                Text("\(viewModel.completedECTS)")
                    .font(.system(size: 34, weight: .bold))

                Text("/ \(viewModel.totalECTS) ECTS")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var studyGoalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Studienziel")
                .font(.headline)

            Text(viewModel.overallStudyScheduleText)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(viewModel.overallStudyScheduleColor)

            Text(scheduleSubtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var statusCardsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Module")
                .font(.headline)

            VStack(spacing: 12) {
                statusCard(
                    title: "Abgeschlossen",
                    value: "\(viewModel.completedModulesCount)",
                    color: .green
                )

                statusCard(
                    title: "Gestartet",
                    value: "\(viewModel.inProgressModulesCount)",
                    color: .orange
                )

                statusCard(
                    title: "Offen",
                    value: "\(viewModel.notStartedModulesCount)",
                    color: .gray
                )
            }
        }
    }

    private func statusCard(title: String, value: String, color: Color) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text("Module")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(color)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private var scheduleSubtitle: String {
        if viewModel.overdueModulesCount > 0 {
            return "\(viewModel.overdueModulesCount) Modul(e) überfällig"
        } else if viewModel.dueSoonModulesCount > 0 {
            return "\(viewModel.dueSoonModulesCount) Modul(e) bald fällig"
        } else if viewModel.inProgressModulesCount > 0 {
            return "Alle gestarteten Module im Zeitplan"
        } else {
            return "Aktuell keine gestarteten Module"
        }
    }
}
