import SwiftUI

enum TimelineEventType {
    case started
    case completed

    var title: String {
        switch self {
        case .started:
            return "Gestartet"
        case .completed:
            return "Abgeschlossen"
        }
    }

    var color: Color {
        switch self {
        case .started:
            return .orange
        case .completed:
            return .green
        }
    }
}
