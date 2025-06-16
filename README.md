# Pokédex App - iOS com SwiftUI

Vinicius Viana
Vinicius da Costa
Marcos Vinicius

## Video
[https://youtube.com/shorts/MLk-SzcYqKg]

## 1\. Descrição Geral

Este é um aplicativo de Pokédex para iOS, desenvolvido de forma nativa com SwiftUI. Ele permite que os usuários explorem o mundo dos Pokémon de uma maneira simples e funcional.

As principais funcionalidades são:

  * **Listagem Infinita:** Navegue por uma lista de Pokémon que carrega mais itens conforme você rola a tela.
  * **Busca em Tempo Real:** Encontre um Pokémon específico digitando seu nome na barra de busca.
  * **Detalhes do Pokémon:** Toque em um Pokémon para ver informações detalhadas, como seus tipos, altura, peso e status base.
  * **Sistema de Usuários e Favoritos:** Crie uma conta, faça login e marque seus Pokémon preferidos para acessá-los rapidamente em uma área dedicada.

## 2\. API: PokeAPI

Para obter todos os dados dos Pokémon, utilizamos a **PokeAPI (pokeapi.co)**.

  * **Por que essa API?**
    A PokeAPI foi escolhida por ser uma fonte de dados gratuita, completa e muito bem documentada sobre o universo Pokémon. Ela oferece todas as informações necessárias para o aplicativo sem a necessidade de chaves de acesso, o que simplifica o desenvolvimento.

  * **Como a API é usada?**
    Toda a comunicação com a API é gerenciada pela classe `PokemonService.swift`. Ela é responsável por duas operações principais:

    1.  `fetchPokemonList(limit:offset:)`: Busca a lista de Pokémon de forma paginada para a rolagem infinita.
    2.  `fetchPokemon(name:)`: Busca os dados detalhados de um único Pokémon pelo seu nome.

  * **Quais dados utilizamos?**
    Após receber a resposta da API, o `PokemonService` decodifica o JSON e transforma os dados na nossa estrutura `PokemonModel`, utilizando informações como:

      * ID, nome e tipos (`types`).
      * URL da imagem oficial (`official-artwork`).
      * Altura (`height`) e peso (`weight`).
      * Estatísticas base (HP, Ataque, Defesa, etc.).

## 3\. Arquitetura do Aplicativo

O projeto foi construído seguindo a arquitetura **MVVM (Model-View-ViewModel)**, que separa as responsabilidades e facilita a manutenção do código.

```
┌───────────┐      ┌─────────────┐      ┌────────────────┐
│   Model   │◀─────│  ViewModel  │◀─────│      View      │
└───────────┘      └─────────────┘      └────────────────┘
(Os dados:       (A lógica de        (A interface que
 PokemonModel,    negócio:            o usuário vê:
 Entidades        PokemonViewModel,   ContentView,
 Core Data)       AuthViewModel)      PokemonDetailView)
```

  * **Model**: Representa a estrutura dos dados do app. Inclui tanto o `PokemonModel` (para os dados da API) quanto as entidades do Core Data (`Usuario` e `PokemonFavorito`).
  * **View**: É a camada de interface gráfica, construída com SwiftUI. As Views são "burras", ou seja, elas apenas exibem os dados e enviam as ações do usuário para a ViewModel (ex: `ContentView`, `PokemonDetailView`).
  * **ViewModel**: Atua como uma ponte entre o Model e a View. Ela contém toda a lógica de negócio: busca os dados da API, gerencia o estado da tela (como `isLoading` ou mensagens de erro) e formata os dados para serem exibidos pela View (ex: `PokemonViewModel`, `AuthViewModel`).

## 4\. Implementação do Core Data

Para o sistema de autenticação e para salvar os Pokémon favoritos, utilizamos o **Core Data**, o framework nativo da Apple para persistência de dados.

  * **Modelo de Dados**
    Temos duas entidades principais:

    1.  **Usuario**: Armazena as informações do usuário, como `id`, `nomeUsuario`, `email` e `senha`.
    2.  **PokemonFavorito**: Armazena os dados básicos de um Pokémon favoritado, como `pokemonID` e `nome`.

    <!-- end list -->

      * Há um **relacionamento de um-para-muitos** entre `Usuario` e `PokemonFavorito`, permitindo que cada usuário tenha sua própria lista de favoritos.

  * **Como os dados são salvos e buscados?**

      * A classe `CoreDataManager` é um Singleton que gerencia a configuração e o acesso ao Core Data, garantindo que todo o app use a mesma instância.
      * A `AuthViewModel` usa o contexto do Core Data para criar, buscar e autenticar usuários. A função `alternarFavorito(pokemon:)` é a responsável por adicionar ou remover um Pokémon da lista de favoritos do usuário logado.

  * **Autenticação Local**
    A autenticação é feita localmente no dispositivo. Quando o usuário tenta fazer login, a `AuthViewModel` busca no Core Data um registro que combine o e-mail e a senha fornecidos. Se encontrado, o ID do usuário é salvo no `UserDefaults` para manter a sessão ativa mesmo após fechar o aplicativo.

## 5\. Design Tokens (DesignSystem)

Para manter a consistência visual do aplicativo e facilitar futuras alterações de design, todos os elementos de estilo foram centralizados em um único arquivo: `DesignSystem.swift`.

  * **Definição:** O arquivo `DesignSystem.swift` organiza cores, fontes, espaçamentos e raios de borda em `enums` estáticos. Por exemplo, `DesignSystem.AppColor.primary` define a cor vermelha principal do app e `DesignSystem.AppFont.largeTitle` define a fonte para títulos grandes.

  * **Uso:** Nas Views, em vez de usar valores "mágicos" como `.red` ou `font(.system(size: 16))`, utilizamos os tokens definidos. Ex: `Color(DesignSystem.AppColor.primary)`. Isso garante que, se precisarmos mudar a cor primária do app, só precisamos alterá-la em um único lugar.

## 6\. Item de Criatividade

O principal item de criatividade do projeto é a **barra de busca animada** (`PokedexSearchBar.swift`).

Ela não é uma barra de busca estática tradicional. Inicialmente, ela se apresenta como um ícone de Pokébola. Ao ser tocada, ela se expande suavemente para a direita, revelando o campo de texto para a busca. Essa animação cria uma experiência mais fluida, interativa e temática, totalmente alinhada à identidade visual do universo Pokémon.

Além disso, um fundo sutil com padrões de Pokébola (`PokeballBackgroundView.swift`) foi adicionado em várias telas para reforçar a imersão.

## 7\. Bibliotecas de Terceiros

Este projeto foi desenvolvido com o objetivo de ser simples e performático, utilizando **apenas frameworks nativos da Apple**. Nenhuma biblioteca de terceiros foi utilizada. As principais tecnologias são:

  * **SwiftUI:** Para a construção de toda a interface de usuário.
  * **Combine:** Para gerenciar operações assíncronas, como as chamadas de API.
  * **Core Data:** Para a persistência de dados locais (usuários e favoritos).
