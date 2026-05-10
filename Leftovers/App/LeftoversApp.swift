import SwiftUI
import SwiftData

@main
struct LeftoversApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Store.self) // Sets up the database
    }
}
