import Foundation

enum ModuleStatus: String, Codable, CaseIterable {
    case notStarted = "Nicht begonnen"
    case inProgress = "Gestartet"
    case completed = "Abgeschlossen"
}
