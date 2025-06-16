import SwiftUI

struct PokeballBackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.width / 5
            let xCount = Int(geometry.size.width / size) + 1
            let yCount = Int(geometry.size.height / size) + 1

            VStack(spacing: 0) {
                ForEach(0..<yCount, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<xCount, id: \.self) { col in
                            PokeballSymbol()
                                .frame(width: size, height: size)
                                .offset(x: (row % 2 == 0) ? 0 : -size / 2)
                        }
                    }
                }
            }
            .frame(width: geometry.size.width + size)
        }
        .ignoresSafeArea()
        .background(Color(.systemGray6))
        .clipped()
    }
}

struct PokeballSymbol: View {
    var body: some View {
        Image(systemName: "circle.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.red, .white.opacity(0.8))
            .opacity(0.05)
    }
}

#Preview {
    PokeballBackgroundView()
}
