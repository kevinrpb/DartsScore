//
//  CricketGameSettingsView.swift
//  DartsScore
//
//  Created by Romero Peces Barba, Kevin on 13/5/23.
//

import SwiftUI

import CricketGame

struct CricketGameSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var game: CricketGame

    var body: some View {
        NavigationStack {
            ZStack {
                Color.green
                    .ignoresSafeArea()

                Color.white.opacity(0.2)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
                        Text("Players:")
                        Spacer()
                    }
                    .padding(.bottom, 2)

                    Picker("Players", selection: $game.numberOfPlayers) {
                        ForEach(CricketGame.PlayerQuantity.allCases, id: \.rawValue) { quantity in
                            Text("\(quantity.rawValue)")
                                .tag(quantity)
                        }
                    }
                    .pickerStyle(.segmented)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
