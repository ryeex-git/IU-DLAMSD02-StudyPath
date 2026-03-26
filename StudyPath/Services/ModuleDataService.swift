import Foundation

final class ModuleDataService {
    func loadModules() -> [StudyModule] {
        guard let url = Bundle.main.url(forResource: "modules", withExtension: "json") else {
            print("modules.json not found")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([StudyModule].self, from: data)
        } catch {
            print("Error loading modules: \(error)")
            return []
        }
    }
}
