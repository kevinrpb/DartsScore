//
//  CricketGame.swift
//  
//  DartsScore/Packages/CricketGame
//  Created by Romero Peces Barba, Kevin on 30/4/23.
//

import SwiftUI

import DartModels

public class CricketGame: ObservableObject {
    public enum Player: Int {
        case p1, p2, p3, p4
    }

    public enum PlayerQuantity: Int, CaseIterable {
        case two = 2
        case three = 3
        case four = 4
    }

    public enum SegmentState {
        case open
        case oneHit
        case twoHits
        case closed(score: Int)

        var score: Int {
            switch self {
            case .closed(let score): return score
            default: return 0
            }
        }
    }

    public struct DartThrow {
        public let player: Player
        public let segment: TargetSegment

        public init(player: CricketGame.Player, segment: TargetSegment) {
            self.player = player
            self.segment = segment
        }
    }

    public typealias TargetSegmentState = [TargetSegment: [Player: SegmentState]]

    @Published public var numberOfPlayers: PlayerQuantity = .two {
        didSet { updateClosures() }
    }
    @Published public var segments: TargetSegmentState = initialSegments
    @Published public var scores: [Player: Int] = initialScores
    @Published public var closures: [TargetSegment: Bool] = initialClosures

    private var throwsUndoHistory: [DartThrow] = []
    private var throwsRedoHistory: [DartThrow] = []

    public init() {}

    public func reset() {
        segments = Self.initialSegments
        scores = Self.initialScores
        closures = Self.initialClosures
        throwsUndoHistory.removeAll()
        throwsRedoHistory.removeAll()
    }
}

// MARK: Throws

extension CricketGame {
    internal func process(_ dartThrow: DartThrow, clearRedo: Bool) {
        guard closures[dartThrow.segment] != true else { return }

        throwsUndoHistory.append(dartThrow)

        if clearRedo {
            throwsRedoHistory.removeAll()
        }

        guard TargetSegment.cricketSegments.contains(dartThrow.segment) else {
            print("[Error] [CricketGame] TargetSegment <\(dartThrow.segment.label)> is not used in Cricket.")
            return
        }

        switch segments[dartThrow.segment]![dartThrow.player]! {
        case .open: segments[dartThrow.segment]![dartThrow.player] = .oneHit
        case .oneHit: segments[dartThrow.segment]![dartThrow.player] = .twoHits
        case .twoHits:
            segments[dartThrow.segment]![dartThrow.player] = .closed(score: 0)
            updateClosures()
        case .closed(let score):
            segments[dartThrow.segment]![dartThrow.player] = .closed(score: score + dartThrow.segment.value)
            scores[dartThrow.player]! += dartThrow.segment.value
        }
    }

    internal func unprocess(_ dartThrow: DartThrow) {
        throwsRedoHistory.append(dartThrow)

        guard TargetSegment.cricketSegments.contains(dartThrow.segment) else {
            print("[Error] [CricketGame] TargetSegment <\(dartThrow.segment.label)> is not used in Cricket.")
            return
        }

        switch segments[dartThrow.segment]![dartThrow.player]! {
        case .open: segments[dartThrow.segment]![dartThrow.player] = .open
        case .oneHit: segments[dartThrow.segment]![dartThrow.player] = .open
        case .twoHits: segments[dartThrow.segment]![dartThrow.player] = .oneHit
        case .closed(let score):
            if score > 0 {
                segments[dartThrow.segment]![dartThrow.player] = .closed(score: score - dartThrow.segment.value)
                scores[dartThrow.player]! -= dartThrow.segment.value
            } else {
                segments[dartThrow.segment]![dartThrow.player] = .twoHits
                updateClosures()
            }
        }
    }

    internal func updateClosures(segment: TargetSegment? = nil) {
        let segmentsToCheck: [TargetSegment] = segment != nil ? [segment!] : TargetSegment.cricketSegments
        let playersToCheck: [Player]

        switch numberOfPlayers {
        case .two: playersToCheck = [.p1, .p2]
        case .three: playersToCheck = [.p1, .p2, .p3]
        case .four: playersToCheck = [.p1, .p2, .p3, .p4]
        }

        for segment in segmentsToCheck {
            var isClosed = true

            for player in playersToCheck {
                if case .closed = segments[segment]![player]! {
                    continue
                } else {
                    isClosed = false
                    break
                }
            }

            closures[segment] = isClosed
        }
    }

    public func process(_ dartThrow: DartThrow) {
        process(dartThrow, clearRedo: true)
    }

    public func undo() {
        guard let dartThrow = throwsUndoHistory.popLast() else { return }
        unprocess(dartThrow)
    }

    public func redo() {
        guard let darThrow = throwsRedoHistory.popLast() else { return }
        process(darThrow, clearRedo: false)
    }

    public var canUndo: Bool { !throwsUndoHistory.isEmpty }
    public var canRedo: Bool { !throwsRedoHistory.isEmpty }
}

// MARK: Default values

internal extension CricketGame {
    static let initialSegments: TargetSegmentState =
        TargetSegment.cricketSegments.reduce(into: [:]) { states, segment in
            states[segment] = [
                .p1: .open,
                .p2: .open,
                .p3: .open,
                .p4: .open
            ]
        }

    static let initialScores: [Player: Int] = [
        .p1: 0,
        .p2: 0,
        .p3: 0,
        .p4: 0
    ]

    static let initialClosures: [TargetSegment: Bool] =
        TargetSegment.cricketSegments.reduce(into: [:]) { states, segment in
            states[segment] = false
        }
}

public extension TargetSegment {
    static let cricketSegments: [TargetSegment] = [.bull, .d15, .d16, .d17, .d18, .d19, .d20]
}
