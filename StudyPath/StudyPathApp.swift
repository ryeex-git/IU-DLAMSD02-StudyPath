import SwiftUI

@main
struct StudyPathApp: App {
    @StateObject private var viewModel = StudyTrackerViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
