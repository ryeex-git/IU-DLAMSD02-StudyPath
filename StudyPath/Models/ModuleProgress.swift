import Foundation

struct ModuleProgress: Codable {
    var status: ModuleStatus
    var startDate: Date?
    var completionDate: Date?
    var grade: Double?
    var notes: String?
    
    init(
        status: ModuleStatus = .notStarted,
        startDate: Date? = nil,
        completionDate: Date? = nil,
        grade: Double? = nil,
        notes: String? = nil
    ) {
        self.status = status
        self.startDate = startDate
        self.completionDate = completionDate
        self.grade = grade
        self.notes = notes
    }
}
