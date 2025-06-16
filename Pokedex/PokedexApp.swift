import SwiftUI

@main
struct PokedexApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    private let viewContext = CoreDataManager.shared.container.viewContext

    var body: some Scene {
        WindowGroup {
            if authViewModel.usuarioLogado != nil {
                ContentView()
                    .environmentObject(authViewModel)
                    .environment(\.managedObjectContext, viewContext)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
}
