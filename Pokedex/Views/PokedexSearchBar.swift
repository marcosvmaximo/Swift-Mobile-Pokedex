// Swift-Mobile-Pokedex/Pokedex/Views/PokedexSearchBar.swift

import SwiftUI

struct PokedexSearchBar: View {
    @Binding var text: String
    
    // Controla a expansão da barra
    @State private var isEditing = false
    // Controla o foco do teclado para a animação de fechar
    @FocusState private var isTextFieldFocused: Bool

    private let barHeight: CGFloat = 60
    private let ballSize: CGFloat = 55

    var body: some View {
        HStack {
            // --- 1. O Botão da Pokébola que inicia a animação ---
            pokeBallButton
                .onTapGesture {
                    // Só anima se já não estiver editando
                    if !isEditing {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            isEditing = true
                            isTextFieldFocused = true // Ativa o teclado
                        }
                    }
                }

            // --- 2. A Barra de Pesquisa que se expande ---
            ZStack {
                // Fundo vermelho da barra
                RoundedRectangle(cornerRadius: barHeight / 2)
                    .fill(Color.red)
                    .frame(height: barHeight)
            
                // Conteúdo interno da barra (campo de texto e botão)
                HStack {
                    // Espaçador para o texto não começar embaixo da pokébola
                    Spacer().frame(width: ballSize)
                    
                    // Campo de texto principal
                    TextField(
                        "",
                        text: $text,
                        prompt: Text("Buscar Pokémon...")
                                    .foregroundColor(Color.white.opacity(0.7))
                    )
                    .foregroundColor(.white)
                    .focused($isTextFieldFocused)
                    
                    // ADICIONADO: Botão para limpar o texto
                    if !text.isEmpty {
                        Spacer().frame(width: 2)
                    
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color.white.opacity(0.8)) // Cor branca para combinar
                        }
                        .padding(.trailing, 12)
                        .transition(.scale) // Adiciona uma animação suave ao botão
                    }
                }
                .padding(.leading)
            }
            .frame(width: isEditing ? nil : 0, height: barHeight) // Anima a largura
            .opacity(isEditing ? 1 : 0) // Anima a opacidade
            .padding(.leading, -ballSize) // Sobrepõe a pokébola para o efeito de expansão
            .zIndex(-1) // Coloca a barra atrás da pokébola na hierarquia visual
        }
        // --- 3. Lógica para fechar a barra ---
        .onChange(of: isTextFieldFocused) { focused in
            // Se o campo de texto perde o foco E está vazio, recolhe a barra
            if !focused && text.isEmpty {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    isEditing = false
                }
            }
        }
    }
    
    // --- 4. O design da Pokébola ---
    private var pokeBallButton: some View {
        ZStack {
            // Metade de baixo (branca)
            Circle()
                .fill(Color.white)
            
            // Metade de cima (vermelha)
            Circle()
                .trim(from: 0.5, to: 1.0)
                .fill(Color.red)
            
            // Círculo central (contorno)
            Circle()
                .stroke(Color.black, lineWidth: 4)
                .frame(width: ballSize / 2, height: ballSize / 2)
            
            // Círculo central (miolo)
            Circle()
                .fill(Color.white)
                .frame(width: ballSize / 3, height: ballSize / 3)
        }
        .frame(width: ballSize, height: ballSize)
        .overlay(Circle().stroke(Color.black, lineWidth: 4))
    }
}

#Preview {
    ContentView()
}
