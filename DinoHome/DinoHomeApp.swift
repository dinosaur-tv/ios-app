import SwiftUI

@main
struct DinoHomeApp: App {
    @StateObject private var webModel = DinoHomeWebModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(webModel)
                .preferredColorScheme(.dark)
                .onOpenURL { webModel.open($0) }
        }
    }
}
