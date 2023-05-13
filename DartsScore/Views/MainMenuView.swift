//
//  MainMenuView.swift
//  DartsScore
//
//  Created by Romero Peces Barba, Kevin on 30/4/23.
//

import SwiftUI

import CricketGame

struct MainMenuView: View {
    private enum Game {
        case cricket, x01

        var label: LocalizedStringKey {
            switch self {
            case .cricket: return "Cricket"
            case .x01: return "X01"
            }
        }
    }

    @StateObject private var cricketGame: CricketGame = .init()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.green.ignoresSafeArea()

                VStack {
                    Spacer()
                    
                    Text("Darts Score")
                        .font(.system(size: 50, weight: .bold))

                    Spacer()

                    NavigationLink(destination: CricketGameView()) {
                        GameButton(.cricket)
                    }

                    NavigationLink(destination: EmptyView()) {
                        GameButton(.x01)
                    }
                    .disabled(true)
                    .overlay(alignment: .bottom) {
                        ComingSoonLabel()
                            .offset(y: 16)
                    }

                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .environmentObject(cricketGame)
    }

    private func GameButton(_ game: Game) -> some View {
        HStack {
            GameSymbol(game)
            Spacer()
            Text(game.label)
                .font(.title)
            Spacer()
            GameSymbol(game)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white.opacity(0.5))
        )
    }

    @ViewBuilder
    private func GameSymbol(_ game: Game) -> some View {
        switch game {
        case .cricket:
            CricketSymbol()
        case .x01:
            X01Symbol()
        }
    }

    private func CricketSymbol() -> some View {
        ZStack {
            Image(systemName: "line.diagonal")
            Image(systemName: "line.diagonal")
                .rotationEffect(.degrees(90))
            Image(systemName: "circle")
                .scaleEffect(0.8)
        }
        .font(.system(size: 24, weight: .bold))
    }

    private func X01Symbol() -> some View {
        ZStack {
            Image(systemName: "arrow.down")
        }
        .font(.system(size: 24, weight: .bold))
    }

    private func ComingSoonLabel() -> some View {
        Text("Coming soon")
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.green, strokeBorder: .black)
            )
    }
}
