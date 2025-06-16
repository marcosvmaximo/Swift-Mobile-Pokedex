// Em Pokedex/Views/LoginView.swift

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var senha = ""
    @State private var mostrarCadastro = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Bem-vindo à Pokedex")
                .font(.largeTitle).fontWeight(.bold)
            
            TextField("E-mail", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            SecureField("Senha", text: $senha)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            if let erro = authViewModel.erroAuth {
                Text(erro).foregroundColor(.red).font(.caption)
            }
            
            Button("Login") {
                authViewModel.login(email: email, senha: senha)
            }
            .padding().frame(maxWidth: .infinity).background(Color.red).foregroundColor(.white).cornerRadius(10)
            
            Button("Não tem uma conta? Cadastre-se") {
                authViewModel.erroAuth = nil // Limpa erros antigos antes de abrir a tela de cadastro
                mostrarCadastro = true
            }
            .font(.footnote)
        }
        .padding()
        .sheet(isPresented: $mostrarCadastro) {
            CadastroView().environmentObject(authViewModel)
        }
    }
}
