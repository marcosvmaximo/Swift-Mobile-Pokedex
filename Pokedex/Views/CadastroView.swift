import SwiftUI

struct CadastroView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var nomeDeUsuario = ""
    @State private var email = ""
    @State private var senha = ""
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large.rawValue) {
            Text("Criar Conta")
                .font(DesignSystem.AppFont.largeTitle)

            TextField("Nome de Usuário", text: $nomeDeUsuario)
                .padding()
                .background(DesignSystem.AppColor.surface)
                .cornerRadius(DesignSystem.CornerRadius.small.rawValue)

            TextField("E-mail", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(DesignSystem.AppColor.surface)
                .cornerRadius(DesignSystem.CornerRadius.small.rawValue)

            SecureField("Senha", text: $senha)
                .padding()
                .background(DesignSystem.AppColor.surface)
                .cornerRadius(DesignSystem.CornerRadius.small.rawValue)

            if let erro = authViewModel.erroAuth {
                Text(erro)
                    .foregroundColor(DesignSystem.AppColor.primary)
                    .font(DesignSystem.AppFont.caption)
            }

            Button("Cadastrar") {
                authViewModel.cadastrar(nomeDeUsuario: nomeDeUsuario, email: email, senha: senha)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(DesignSystem.AppColor.primary)
            .foregroundColor(DesignSystem.AppColor.onPrimary)
            .cornerRadius(DesignSystem.CornerRadius.small.rawValue)
        }
        .padding()
        .onChange(of: authViewModel.usuarioLogado) { newUser in
            if newUser != nil {
                dismiss()
            }
        }
    }
}
