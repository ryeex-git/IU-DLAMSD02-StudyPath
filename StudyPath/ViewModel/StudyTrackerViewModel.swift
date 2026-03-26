import Foundation
import Combine

final class StudyTrackerViewModel: ObservableObject {
    @Published var modules: [StudyModule] = []
    @Published var progress: [String: ModuleProgress] = [:]

    private let moduleDataService = ModuleDataService()
    private let progressStorageService = ProgressStorageService()

    init() {
        loadData()
    }

    func loadData() {
        modules = moduleDataService.loadModules()
        progress = progressStorageService.loadProgress()
    }

    func progressForModule(_ module: StudyModule) -> ModuleProgress {
        progress[module.id] ?? ModuleProgress()
    }

    func updateStatus(for module: StudyModule, to status: ModuleStatus) {
        var currentProgress = progress[module.id] ?? ModuleProgress()

        switch status {
        case .notStarted:
            currentProgress.status = .notStarted
            currentProgress.startDate = nil
            currentProgress.completionDate = nil
            currentProgress.grade = nil

        case .inProgress:
            currentProgress.status = .inProgress
            if currentProgress.startDate == nil {
                currentProgress.startDate = Date()
            }
            currentProgress.completionDate = nil

        case .completed:
            currentProgress.status = .completed
            if currentProgress.startDate == nil {
                currentProgress.startDate = Date()
            }
            currentProgress.completionDate = Date()
        }

        progress[module.id] = currentProgress
        saveProgress()
    }

    func updateNotes(for module: StudyModule, notes: String) {
        var currentProgress = progress[module.id] ?? ModuleProgress()
        currentProgress.notes = notes
        progress[module.id] = currentProgress
        saveProgress()
    }

    func updateGrade(for module: StudyModule, grade: Double?) {
        var currentProgress = progress[module.id] ?? ModuleProgress()
        currentProgress.grade = grade
        progress[module.id] = currentProgress
        saveProgress()
    }

    func saveProgress() {
        progressStorageService.saveProgress(progress)
    }

    var completedModulesCount: Int {
        modules.filter { progress[$0.id]?.status == .completed }.count
    }

    var inProgressModulesCount: Int {
        modules.filter { progress[$0.id]?.status == .inProgress }.count
    }

    var notStartedModulesCount: Int {
        modules.count - completedModulesCount - inProgressModulesCount
    }

    var totalECTS: Int {
        modules.reduce(0) { $0 + $1.ects }
    }

    var completedECTS: Int {
        modules
            .filter { progress[$0.id]?.status == .completed }
            .reduce(0) { $0 + $1.ects }
    }

    var progressPercentage: Double {
        guard totalECTS > 0 else { return 0 }
        return Double(completedECTS) / Double(totalECTS)
    }

    var modulesGroupedBySemester: [Int: [StudyModule]] {
        Dictionary(grouping: modules, by: { $0.semester })
    }

    var sortedSemesters: [Int] {
        modulesGroupedBySemester.keys.sorted()
    }
}
