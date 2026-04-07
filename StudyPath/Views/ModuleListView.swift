import SwiftUI

struct ModuleListView: View {
    @EnvironmentObject var viewModel: StudyTrackerViewModel

    @State private var searchText: String = ""
    @State private var selectedFilter: ModuleFilter = .all
    @State private var expandedSemesters: Set<Int> = []

    var body: some View {
        VStack(spacing: 0) {
            searchAndFilterSection

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(filteredSemesters, id: \.self) { semester in
                        let semesterModules = filteredModulesBySemester[semester] ?? []

                        if !semesterModules.isEmpty {
                            VStack(spacing: 0) {
                                semesterHeader(for: semester, modules: semesterModules)

                                if isExpanded(semester) {
                                    VStack(spacing: 12) {
                                        ForEach(semesterModules) { module in
                                            NavigationLink(destination: ModuleDetailView(module: module)) {
                                                ModuleRowView(module: module)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                    .padding(.top, 12)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
        }
        .navigationTitle("Module")
        .background(Color(.systemGroupedBackground))
        .onAppear {
            initializeExpandedSemesters()
        }
    }

    private var searchAndFilterSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)

                TextField("Modul suchen", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            .padding(12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))

            Picker("Filter", selection: $selectedFilter) {
                ForEach(ModuleFilter.allCases, id: \.self) { filter in
                    Text(filter.title).tag(filter)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }

    private func semesterHeader(for semester: Int, modules: [StudyModule]) -> some View {
        Button {
            toggleSemester(semester)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text("Semester \(semester)")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        if isSemesterCompleted(modules) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }

                    Text(semesterSubtitle(for: modules))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: isExpanded(semester) ? "chevron.up" : "chevron.down")
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.plain)
    }

    private func semesterSubtitle(for modules: [StudyModule]) -> String {
        let completed = modules.filter { viewModel.progressForModule($0).status == .completed }.count
        let total = modules.count

        if completed == total {
            return "Abgeschlossen"
        } else {
            return "\(completed) von \(total) Modulen abgeschlossen"
        }
    }

    private var filteredModules: [StudyModule] {
        viewModel.modules.filter { module in
            let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

            let matchesSearch =
                trimmedSearch.isEmpty ||
                module.name.localizedCaseInsensitiveContains(trimmedSearch) ||
                module.code.localizedCaseInsensitiveContains(trimmedSearch)

            let status = viewModel.progressForModule(module).status
            let matchesFilter = selectedFilter.matches(status: status)

            return matchesSearch && matchesFilter
        }
    }

    private var filteredModulesBySemester: [Int: [StudyModule]] {
        Dictionary(grouping: filteredModules, by: { $0.semester })
    }

    private var filteredSemesters: [Int] {
        filteredModulesBySemester.keys.sorted()
    }

    private func isSemesterCompleted(_ modules: [StudyModule]) -> Bool {
        modules.allSatisfy { viewModel.progressForModule($0).status == .completed }
    }

    private func isExpanded(_ semester: Int) -> Bool {
        expandedSemesters.contains(semester)
    }

    private func toggleSemester(_ semester: Int) {
        if expandedSemesters.contains(semester) {
            expandedSemesters.remove(semester)
        } else {
            expandedSemesters.insert(semester)
        }
    }

    private func initializeExpandedSemesters() {
        guard expandedSemesters.isEmpty else { return }

        for semester in filteredSemesters {
            let modules = filteredModulesBySemester[semester] ?? []
            if !isSemesterCompleted(modules) {
                expandedSemesters.insert(semester)
            }
        }
    }
}
