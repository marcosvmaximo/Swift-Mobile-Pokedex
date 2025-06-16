import SwiftUI

struct PokedexSearchBar: View {
    @Binding var text: String
    
    @State private var isEditing = false
    @FocusState private var isTextFieldFocused: Bool

    private let barHeight: CGFloat = 60
    private let ballSize: CGFloat = 55

    var body: some View {
        HStack {
            pokeBallButton
                .onTapGesture {
                    if !isEditing {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            isEditing = true
                            isTextFieldFocused = true
                        }
                    }
                }

            ZStack {
                RoundedRectangle(cornerRadius: barHeight / 2)
                    .fill(DesignSystem.AppColor.primary)
                    .frame(height: barHeight)
            
                HStack {
                    Spacer().frame(width: ballSize)
                    
                    TextField(
                        "",
                        text: $text,
                        prompt: Text("Buscar Pokémon...")
                                    .foregroundColor(DesignSystem.AppColor.onPrimary.opacity(0.7))
                    )
                    .foregroundColor(DesignSystem.AppColor.onPrimary)
                    .focused($isTextFieldFocused)
                    
                    if !text.isEmpty {
                        Spacer().frame(width: 2)
                    
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(DesignSystem.AppColor.onPrimary.opacity(0.8))
                        }
                        .padding(.trailing, 12)
                        .transition(.scale)
                    }
                }
                .padding(.leading)
            }
            .frame(width: isEditing ? nil : 0, height: barHeight)
            .opacity(isEditing ? 1 : 0)
            .padding(.leading, -ballSize)
            .zIndex(-1)
        }
        .onChange(of: isTextFieldFocused) { focused in
            if !focused && text.isEmpty {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    isEditing = false
                }
            }
        }
    }
    
    private var pokeBallButton: some View {
        ZStack {
            Circle().fill(DesignSystem.AppColor.onPrimary)
            Circle().trim(from: 0.5, to: 1.0).fill(DesignSystem.AppColor.primary)
            Circle().stroke(Color.black, lineWidth: 4).frame(width: ballSize / 2, height: ballSize / 2)
            Circle().fill(DesignSystem.AppColor.onPrimary).frame(width: ballSize / 3, height: ballSize / 3)
        }
        .frame(width: ballSize, height: ballSize)
        .overlay(Circle().stroke(Color.black, lineWidth: 4))
    }
}
