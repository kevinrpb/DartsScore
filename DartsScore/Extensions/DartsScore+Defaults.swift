//
//  DartsScore+Defaults.swift
//  DartsScore
//
//  Created by Romero Peces Barba, Kevin on 30/4/23.
//

import Foundation

import Defaults

import CricketGame

extension Defaults.Keys {
    static let cricketGamePlayerNames: Defaults.Key<[String]> =
        .init("cricketGamePlayerNames", default: ["Player 1", "Player 2", "Player 3", "Player 4"])
}
