import SwiftUI
import Combine

struct PokemonDetailView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var pokemon: PokemonModel
    @State private var isLoading = false
    @State private var cancellables = Set<AnyCancellable>()
    
    private var themeColor: Color {
        DesignSystem.AppColor.PokemonType.color(for: pokemon.types.first?.lowercased() ?? "normal")
    }

    var body: some View {
        ZStack {
            themeColor.ignoresSafeArea()
            
            if isLoading {
                ProgressView("Carregando Detalhes...")
                    .tint(.white)
            } else {
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.large.rawValue) {
                        AsyncImage(url: pokemon.imageURL) { image in
                            image.resizable().aspectRatio(contentMode: .fit).shadow(radius: 10)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 250)

                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xlarge.rawValue) {
                            HStack {
                                Text(pokemon.name)
                                    .font(DesignSystem.AppFont.largeTitle)
                                    .foregroundColor(DesignSystem.AppColor.textPrimary)
                                
                                Spacer()
                                
                                Button(action: {
                                    authViewModel.alternarFavorito(pokemon: pokemon)
                                }) {
                                    Image(systemName: authViewModel.ehFavorito(pokemon: pokemon) ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .font(.title)
                                }
                            }
                            
                            HStack {
                                ForEach(pokemon.types, id: \.self) { typeName in
                                    Text(typeName)
                                        .font(DesignSystem.AppFont.headline)
                                        .foregroundColor(DesignSystem.AppColor.onPrimary)
                                        .padding(.horizontal, DesignSystem.Spacing.medium.rawValue)
                                        .padding(.vertical, DesignSystem.Spacing.small.rawValue)
                                        .background(DesignSystem.AppColor.PokemonType.color(for: typeName.lowercased()))
                                        .clipShape(Capsule())
                                }
                            }
                            
                            Divider()
                            
                            HStack {
                                Spacer()
                                MetricInfoView(title: "Height", value: "\(String(format: "%.1f", pokemon.height)) m")
                                Spacer()
                                MetricInfoView(title: "Weight", value: "\(String(format: "%.1f", pokemon.weight)) kg")
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium.rawValue) {
                                Text("Base Stats").font(DesignSystem.AppFont.title2)
                                
                                ForEach(pokemon.stats) { stat in
                                    StatRowView(stat: stat, barColor: themeColor)
                                }
                            }
                        }
                        .padding()
                        .background(DesignSystem.AppColor.background)
                        .cornerRadius(DesignSystem.CornerRadius.large.rawValue)
                        .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(pokemon.name)
        .onAppear(perform: loadFullPokemonData)
    }

    private func loadFullPokemonData() {
        guard pokemon.stats.isEmpty else { return }
        
        isLoading = true
        
        PokemonService.shared.fetchPokemon(name: pokemon.name.lowercased())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                isLoading = false
                if case .failure(let error) = completion {
                    print("Erro ao carregar detalhes do favorito: \(error.localizedDescription)")
                }
            }, receiveValue: { fullPokemon in
                self.pokemon = fullPokemon
            })
            .store(in: &cancellables)
    }
}

struct MetricInfoView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(DesignSystem.AppFont.subheadline)
                .foregroundColor(DesignSystem.AppColor.textSecondary)
            Text(value)
                .font(DesignSystem.AppFont.headline)
        }
    }
}
