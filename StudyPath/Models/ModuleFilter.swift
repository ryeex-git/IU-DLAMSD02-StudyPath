import Foundation

enum ModuleFilter: CaseIterable {
    case all
    case notStarted
    case inProgress
    case completed

    var title: String {
        switch self {
        case .all:
            return "Alle"
        case .notStarted:
            return "Offen"
        case .inProgress:
            return "Gestartet"
        case .completed:
            return "Fertig"
        }
    }

    func matches(status: ModuleStatus) -> Bool {
        switch self {
        case .all:
            return true
        case .notStarted:
            return status == .notStarted
        case .inProgress:
            return status == .inProgress
        case .completed:
            return status == .completed
        }
    }
}
