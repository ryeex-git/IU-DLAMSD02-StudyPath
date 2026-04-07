import SwiftUI

enum ModuleScheduleStatus {
    case onTrack
    case dueSoon
    case overdue

    var title: String {
        switch self {
        case .onTrack:
            return "Im Zeitplan"
        case .dueSoon:
            return "Bald fällig"
        case .overdue:
            return "Überfällig"
        }
    }

    var color: Color {
        switch self {
        case .onTrack:
            return .green
        case .dueSoon:
            return .orange
        case .overdue:
            return .red
        }
    }
}
