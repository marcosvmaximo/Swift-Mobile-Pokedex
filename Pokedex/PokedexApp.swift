// Em Pokedex/PokedexApp.swift

import SwiftUI

@main
struct PokedexApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    // --- ALTERAÇÃO PRINCIPAL ---
    // Removemos a criação de uma nova instância e passamos a usar
    // o contexto da instância única (Singleton) do CoreDataManager.
    // Isso garante que todo o aplicativo use o mesmo stack do Core Data.
    private let viewContext = CoreDataManager.shared.container.viewContext

    var body: some Scene {
        WindowGroup {
            // A lógica aqui permanece a mesma, mas agora o contexto injetado
            // é o mesmo que o AuthViewModel utiliza.
            if authViewModel.usuarioLogado != nil {
                ContentView()
                    .environmentObject(authViewModel)
                    .environment(\.managedObjectContext, viewContext)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
                    // Também injetamos o contexto aqui para consistência
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
}
