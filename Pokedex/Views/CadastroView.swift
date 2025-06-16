import SwiftUI

struct CadastroView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var nomeDeUsuario = ""
    @State private var email = ""
    @State private var senha = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Criar Conta").font(.largeTitle).fontWeight(.bold)
            TextField("Nome de Usuário", text: $nomeDeUsuario).padding().background(Color(.systemGray6)).cornerRadius(10)
            TextField("E-mail", text: $email).keyboardType(.emailAddress).autocapitalization(.none).padding().background(Color(.systemGray6)).cornerRadius(10)
            SecureField("Senha", text: $senha).padding().background(Color(.systemGray6)).cornerRadius(10)

            if let erro = authViewModel.erroAuth {
                Text(erro).foregroundColor(.red).font(.caption)
            }

            Button("Cadastrar") {
                authViewModel.cadastrar(nomeDeUsuario: nomeDeUsuario, email: email, senha: senha)
            }
            .padding().frame(maxWidth: .infinity).background(Color.red).foregroundColor(.white).cornerRadius(10)
        }
        .padding()
        .onChange(of: authViewModel.usuarioLogado) { newUser in
            if newUser != nil {
                dismiss()
            }
        }
    }
}
