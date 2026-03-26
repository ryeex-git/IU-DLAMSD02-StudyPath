import Foundation

struct StudyModule: Identifiable, Codable {
    let id: String
    let code: String
    let name: String
    let semester: Int
    let ects: Int
    let examType: String
}
