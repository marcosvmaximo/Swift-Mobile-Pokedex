import Foundation
import CoreData
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var usuarioLogado: Usuario?
    @Published var erroAuth: String?

    private let context = CoreDataManager.shared.context

    init() {
        verificarStatusLogin()
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func cadastrar(nomeDeUsuario: String, email: String, senha: String) {
        self.erroAuth = nil

        guard !nomeDeUsuario.isEmpty, !email.isEmpty, !senha.isEmpty else {
            self.erroAuth = "Todos os campos são obrigatórios."
            return
        }
        
        guard isValidEmail(email) else {
            self.erroAuth = "O formato do e-mail é inválido."
            return
        }
        
        guard senha.count >= 6 else {
            self.erroAuth = "A senha deve conter pelo menos 6 caracteres."
            return
        }
        
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email.lowercased())
        
        if let _ = try? context.fetch(request).first {
            self.erroAuth = "Este e-mail já está em uso."
            return
        }

        let novoUsuario = Usuario(context: context)
        novoUsuario.id = UUID()
        novoUsuario.nomeUsuario = nomeDeUsuario
        novoUsuario.email = email.lowercased()
        novoUsuario.senha = senha
        
        CoreDataManager.shared.save()
        login(email: email, senha: senha)
    }

    func login(email: String, senha: String) {
        self.erroAuth = nil

        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND senha == %@", email.lowercased(), senha)

        do {
            if let usuario = try context.fetch(request).first {
                self.usuarioLogado = usuario
                UserDefaults.standard.set(usuario.id?.uuidString, forKey: "usuarioLogadoID")
            } else {
                self.erroAuth = "E-mail ou senha inválidos."
            }
        } catch {
            self.erroAuth = "Ocorreu um erro ao tentar fazer login."
        }
    }

    func logout() {
        self.usuarioLogado = nil
        UserDefaults.standard.removeObject(forKey: "usuarioLogadoID")
    }

    private func verificarStatusLogin() {
        guard let userIDString = UserDefaults.standard.string(forKey: "usuarioLogadoID"),
              let userID = UUID(uuidString: userIDString) else { return }

        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", userID as CVarArg)

        if let usuario = try? context.fetch(request).first {
            self.usuarioLogado = usuario
        }
    }
    
    func ehFavorito(pokemon: PokemonModel) -> Bool {
        guard let usuario = self.usuarioLogado else {
            return false
        }
        
        let request: NSFetchRequest<PokemonFavorito> = PokemonFavorito.fetchRequest()
        request.predicate = NSPredicate(format: "pokemonID == %d AND usuario == %@", pokemon.id, usuario)
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Erro ao verificar favorito: \(error)")
            return false
        }
    }

    func alternarFavorito(pokemon: PokemonModel) {
        guard let usuario = usuarioLogado else { return }

        let request: NSFetchRequest<PokemonFavorito> = PokemonFavorito.fetchRequest()
        request.predicate = NSPredicate(format: "pokemonID == %d AND usuario == %@", pokemon.id, usuario)

        do {
            if let favoritoExistente = try context.fetch(request).first {
                context.delete(favoritoExistente)
            } else {
                let novoFavorito = PokemonFavorito(context: context)
                novoFavorito.pokemonID = Int64(pokemon.id)
                novoFavorito.nome = pokemon.name
                novoFavorito.imagemUrl = pokemon.imageURL?.absoluteString
                novoFavorito.tipos = pokemon.types.joined(separator: ",")
                
                novoFavorito.usuario = usuario
            }
            
            CoreDataManager.shared.save()
            
            self.objectWillChange.send()

        } catch {
            print("Erro ao alternar favorito: \(error)")
        }
    }
}
