import SwiftUI

struct PokeballBackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.width / 5 // Tamanho de cada pokébola
            let xCount = Int(geometry.size.width / size) + 1
            let yCount = Int(geometry.size.height / size) + 1

            VStack(spacing: 0) {
                ForEach(0..<yCount, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<xCount, id: \.self) { col in
                            PokeballSymbol()
                                .frame(width: size, height: size)
                                // Alterna a posição para um efeito de "tijolo"
                                .offset(x: (row % 2 == 0) ? 0 : -size / 2)
                        }
                    }
                }
            }
            // Garante que o padrão cubra a tela toda, mesmo com o offset
            .frame(width: geometry.size.width + size)
        }
        .ignoresSafeArea()
        .background(Color(.systemGray6))
        .clipped() // Garante que nada desenhado fora da área seja visível
    }
}

struct PokeballSymbol: View {
    var body: some View {
        Image(systemName: "circle.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.red, .white.opacity(0.8))
            .opacity(0.05) // Deixa o ícone bem sutil
    }
}

#Preview {
    PokeballBackgroundView()
}
