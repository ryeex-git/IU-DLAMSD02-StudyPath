import Foundation
import Combine
import SwiftUI

final class StudyTrackerViewModel: ObservableObject {
    @Published var modules: [StudyModule] = []
    @Published var progress: [String: ModuleProgress] = [:]

    private let moduleDataService = ModuleDataService()
    private let progressStorageService = ProgressStorageService()

    init() {
        loadData()
        //loadMockProgressForScreenshots()
    }

    func loadData() {
        modules = moduleDataService.loadModules()
        progress = progressStorageService.loadProgress()
    }

    func loadMockProgressForScreenshots() {
        let calendar = Calendar.current
        let today = Date()

        progress = [
            // Abgeschlossen
            "oop-java": ModuleProgress(
                status: .completed,
                startDate: calendar.date(byAdding: .day, value: -90, to: today),
                completionDate: calendar.date(byAdding: .day, value: -60, to: today),
                grade: 1.7,
                notes: "Erfolgreich abgeschlossen"
            ),
            "softwaretechnik": ModuleProgress(
                status: .completed,
                startDate: calendar.date(byAdding: .day, value: -75, to: today),
                completionDate: calendar.date(byAdding: .day, value: -48, to: today),
                grade: 2.0,
                notes: nil
            ),
            "datenbanken": ModuleProgress(
                status: .completed,
                startDate: calendar.date(byAdding: .day, value: -70, to: today),
                completionDate: calendar.date(byAdding: .day, value: -40, to: today),
                grade: 2.3,
                notes: nil
            ),

            // Gestartet - im Zeitplan
            "wissenschaftliches-arbeiten": ModuleProgress(
                status: .inProgress,
                startDate: calendar.date(byAdding: .day, value: -10, to: today),
                completionDate: nil,
                grade: nil,
                notes: "Bearbeitung läuft"
            ),
            "requirements-engineering": ModuleProgress(
                status: .inProgress,
                startDate: calendar.date(byAdding: .day, value: -18, to: today),
                completionDate: nil,
                grade: nil,
                notes: nil
            ),

            // Gestartet - bald fällig
            "kollaboratives-arbeiten": ModuleProgress(
                status: .inProgress,
                startDate: calendar.date(byAdding: .day, value: -38, to: today),
                completionDate: nil,
                grade: nil,
                notes: "Bald abgeben"
            ),

            // Gestartet - überfällig
            "spezifikation": ModuleProgress(
                status: .inProgress,
                startDate: calendar.date(byAdding: .day, value: -50, to: today),
                completionDate: nil,
                grade: nil,
                notes: "Frist überschritten"
            ),

            // Noch nicht begonnen
            "datenstrukturen-java": ModuleProgress(status: .notStarted),
            "web-ui": ModuleProgress(status: .notStarted),
            "algorithmen": ModuleProgress(status: .notStarted)
        ]

        saveProgress()
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
    
    func targetDate(for module: StudyModule) -> Date? {
        guard let startDate = progress[module.id]?.startDate else { return nil }
        return Calendar.current.date(byAdding: .weekOfYear, value: 6, to: startDate)
    }
    
    func daysRemaining(for module: StudyModule) -> Int? {
        guard let targetDate = targetDate(for: module) else { return nil }
        return Calendar.current.dateComponents([.day], from: Date(), to: targetDate).day
    }
    
    func scheduleStatus(for module: StudyModule) -> ModuleScheduleStatus? {
        guard let progress = progress[module.id],
              progress.status == .inProgress,
              let remainingDays = daysRemaining(for: module) else {
            return nil
        }

        if remainingDays < 0 {
            return .overdue
        } else if remainingDays <= 7 {
            return .dueSoon
        } else {
            return .onTrack
        }
    }
    
    var onTrackModulesCount: Int {
        modules.filter { scheduleStatus(for: $0) == .onTrack }.count
    }

    var dueSoonModulesCount: Int {
        modules.filter { scheduleStatus(for: $0) == .dueSoon }.count
    }

    var overdueModulesCount: Int {
        modules.filter { scheduleStatus(for: $0) == .overdue }.count
    }

    var overallStudyScheduleText: String {
        if overdueModulesCount > 0 {
            return "Im Verzug"
        } else if dueSoonModulesCount > 0 {
            return "Leicht im Rückstand"
        } else {
            return "Im Zeitplan"
        }
    }
    
    var overallStudyScheduleColor: Color {
        if overdueModulesCount > 0 {
            return .red
        } else if dueSoonModulesCount > 0 {
            return .orange
        } else {
            return .green
        }
    }
}
