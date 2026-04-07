import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .dashboard

    var body: some View {
        VStack(spacing: 0) {

            Group {
                switch selectedTab {
                case .dashboard:
                    NavigationStack {
                        DashboardView()
                    }

                case .modules:
                    NavigationStack {
                        ModuleListView()
                    }

                case .timeline:
                    NavigationStack {
                        TimelineView()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Divider()

            CustomTabBar(selectedTab: $selectedTab)
                .background(Color.white)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .preferredColorScheme(.light)
    }
}
