import Foundation

final class ProgressStorageService {
    private let progressKey = "study_progress"

    func loadProgress() -> [String: ModuleProgress] {
        guard let data = UserDefaults.standard.data(forKey: progressKey) else {
            return [:]
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([String: ModuleProgress].self, from: data)
        } catch {
            print("Error loading progress: \(error)")
            return [:]
        }
    }

    func saveProgress(_ progress: [String: ModuleProgress]) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(progress)
            UserDefaults.standard.set(data, forKey: progressKey)
        } catch {
            print("Error saving progress: \(error)")
        }
    }
}
