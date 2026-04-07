import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack {
            tabButton(
                title: "Dashboard",
                systemImage: "chart.pie.fill",
                tab: .dashboard
            )

            Spacer()

            tabButton(
                title: "Module",
                systemImage: "list.bullet",
                tab: .modules
            )

            Spacer()

            tabButton(
                title: "Timeline",
                systemImage: "calendar",
                tab: .timeline
            )
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .background(Color.white)
    }

    @ViewBuilder
    private func tabButton(title: String, systemImage: String, tab: AppTab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .semibold))

                Text(title)
                    .font(.caption)
            }
            .foregroundColor(selectedTab == tab ? .blue : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.dashboard))
}
