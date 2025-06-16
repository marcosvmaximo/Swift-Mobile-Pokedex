import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var senha = ""
    @State private var mostrarCadastro = false

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large.rawValue) {
            Text("Bem-vindo à Pokedex")
                .font(DesignSystem.AppFont.largeTitle)
            
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
            
            Button("Login") {
                authViewModel.login(email: email, senha: senha)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(DesignSystem.AppColor.primary)
            .foregroundColor(DesignSystem.AppColor.onPrimary)
            .cornerRadius(DesignSystem.CornerRadius.small.rawValue)
            
            Button("Não tem uma conta? Cadastre-se") {
                authViewModel.erroAuth = nil
                mostrarCadastro = true
            }
            .font(DesignSystem.AppFont.footnote)
        }
        .padding()
        .sheet(isPresented: $mostrarCadastro) {
            CadastroView().environmentObject(authViewModel)
        }
    }
}
