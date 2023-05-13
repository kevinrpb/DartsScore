//
//  CricketGameView.swift
//  DartsScore
//
//  Created by Romero Peces Barba, Kevin on 30/4/23.
//

import SwiftUI

import Defaults

import CricketGame
import DartModels

struct CricketGameView: View {
    private enum SheetType: Int, Identifiable {
        case settings

        var id: Int { rawValue }
    }

    private enum AlertType: Int, Identifiable {
        case nameEdit
        case resetConfirm

        var title: LocalizedStringKey {
            switch self {
            case .nameEdit: return "Edit Player"
            case .resetConfirm: return "Confirm Reset"
            }
        }
        var id: Int { rawValue }
    }

    @EnvironmentObject var game: CricketGame

    @Default(.cricketGamePlayerNames) private var playerNames

    @State private var currentSheet: SheetType? = nil
    @State private var showNameEditAlert: Bool = false
    @State private var nameEditAlertPlayer: Int? = nil
    @State private var nameEditAlertName: String = ""
    @State private var showResetConfirmAlert: Bool = false

    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Table()
                Spacer()
                ButtonToolbar()
            }
            .padding(.top)
            .frame(idealWidth: .infinity)
        }
        .sheet(item: $currentSheet) { sheetType in
            switch sheetType {
            case .settings:
                CricketGameSettingsView()
                    .presentationDetents([.height(150), .medium])
            }
        }
        .alert("Edit player", isPresented: $showNameEditAlert, presenting: nameEditAlertPlayer) { playerIndex in
            TextField("Name", text: $playerNames[playerIndex])
            Button("OK") {
                if playerNames[playerIndex].isEmpty {
                    playerNames[playerIndex] = "Player"
                }

                showNameEditAlert = false
            }
        }
        .alert("Reset game?", isPresented: $showResetConfirmAlert) {
            Button("Confirm", role: .destructive) {
                game.reset()
            }

            Button("Cancel", role: .cancel) {}
        }
        .navigationTitle("Cricket")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func Table() -> some View {
        LazyVGrid(
            columns: Array(repeating: .init(spacing: 0), count: 5),
            alignment: .center,
            spacing: 0
        ) {
            TableHeader()
            ForEach(TargetSegment.cricketSegments.reversed(), id: \.value) { segment in
                TableRow(segment: segment)
                    .id(segment.value)
            }
        }
    }

    @ViewBuilder
    private func TableHeader() -> some View {
        switch game.numberOfPlayers {
        case .two:
            TableCell(background: .white.opacity(0.8)) { Image(systemName: "plus") }
                .onTapGesture {
                    game.numberOfPlayers = .three
                }
            TableHeaderCell(player: .p1)
            TableCell(background: .black) { Spacer() }
            TableHeaderCell(player: .p2)
            TableCell(background: .white.opacity(0.8)) { Spacer() }
        case .three:
            TableHeaderCell(player: .p3)
            TableHeaderCell(player: .p1)
            TableCell(background: .black) { Spacer() }
            TableHeaderCell(player: .p2)
            TableCell(background: .white.opacity(0.8)) { Image(systemName: "plus") }
                .onTapGesture {
                    game.numberOfPlayers = .four
                }
        case .four:
            TableHeaderCell(player: .p3)
            TableHeaderCell(player: .p1)
            TableCell(background: .black) { Spacer() }
            TableHeaderCell(player: .p2)
            TableHeaderCell(player: .p4)
        }
    }

    @ViewBuilder
    private func TableHeaderCell(player: CricketGame.Player) -> some View {
        TableCell(background: .white.opacity(0.8)) {
            Text(playerNames[player.rawValue])
            Spacer()
            Text("\(game.scores[player]!)")
                .font(.body.bold())
        }
        .border(.black)
        .onLongPressGesture {
            nameEditAlertPlayer = player.rawValue
            showNameEditAlert = true
        }
    }

    @ViewBuilder
    private func TableRow(segment: TargetSegment) -> some View {
        switch game.numberOfPlayers {
        case .two:
            TableCell { Spacer() }
            TableRowCell(segment: segment, player: .p1)
            TableRowCell(segment: segment)
            TableRowCell(segment: segment, player: .p2)
            TableCell { Spacer() }
        case .three:
            TableRowCell(segment: segment, player: .p3)
            TableRowCell(segment: segment, player: .p1)
            TableRowCell(segment: segment)
            TableRowCell(segment: segment, player: .p2)
            TableCell { Spacer() }
        case .four:
            TableRowCell(segment: segment, player: .p3)
            TableRowCell(segment: segment, player: .p1)
            TableRowCell(segment: segment)
            TableRowCell(segment: segment, player: .p2)
            TableRowCell(segment: segment, player: .p4)
        }
    }

    private func TableRowCell(segment: TargetSegment, player: CricketGame.Player) -> some View {
        TableCell {
            ZStack {
                switch game.segments[segment]![player]! {
                case .open:
                    Spacer()
                case .oneHit:
                    Image(systemName: "line.diagonal")
                case .twoHits:
                    Image(systemName: "line.diagonal")
                    Image(systemName: "line.diagonal")
                        .rotationEffect(.degrees(90))
                case .closed:
                    Image(systemName: "line.diagonal")
                    Image(systemName: "line.diagonal")
                        .rotationEffect(.degrees(90))
                    Image(systemName: "circle")
                        .scaleEffect(0.8)
                }

                Image(systemName: "circle")
                    .scaleEffect(0.8)
                    .opacity(0.000001)
            }
            .font(.system(size: 40, weight: .bold))
        }
        .overlay(
            Rectangle()
                .opacity(0.000001)
                .onTapGesture {
                    game.process(.init(player: player, segment: segment))
                }
        )
    }

    private func TableRowCell(segment: TargetSegment) -> some View {
        TableCell(background: .black) {
            Text(segment.label)
                .strikethrough(game.closures[segment]!)
                .foregroundColor(.white)
        }
        .border(.black)
    }

    private func TableCell<Content: View>(
        background: Color = .white.opacity(0.2),
        border: Color = .black,
        @ViewBuilder _ content: @escaping () -> Content
    ) -> some View {
        ZStack {
            background

            HStack {
                Spacer()
                VStack {
                    Spacer()
                    content()
                    Spacer()
                }
                Spacer()
            }
            .border(border)
        }
    }

    private func ButtonToolbar() -> some View {
        LazyVGrid(columns: Array(repeating: .init(), count: 4)) {
            TableCell(background: .clear, border: .clear) {
                Button { game.undo() } label: {
                    Label("Undo", systemImage: "arrowshape.turn.up.left.fill")
                        .labelStyle(.iconOnly)
                }
                .disabled(!game.canUndo)
            }

            TableCell(background: .clear, border: .clear) {
                Button { game.redo() } label: {
                    Label("Redo", systemImage: "arrowshape.turn.up.right.fill")
                        .labelStyle(.iconOnly)
                }
                .disabled(!game.canRedo)
            }

            TableCell(background: .clear, border: .clear) {
                Button { currentSheet = .settings } label: {
                    Label("Open settings", systemImage: "gear")
                        .labelStyle(.iconOnly)
                }
            }

            TableCell(background: .clear, border: .clear) {
                Button { showResetConfirmAlert = true } label: {
                    Label("Reset game", systemImage: "arrow.counterclockwise")
                        .labelStyle(.iconOnly)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .background(
            Rectangle()
                .fill(.white.opacity(0.2))
                .ignoresSafeArea(edges: .bottom)
        )
    }
}
