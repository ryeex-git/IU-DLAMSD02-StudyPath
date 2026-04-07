import Foundation

struct TimelineEntry: Identifiable {
    let id = UUID()
    let moduleName: String
    let moduleCode: String
    let date: Date
    let eventType: TimelineEventType
}
