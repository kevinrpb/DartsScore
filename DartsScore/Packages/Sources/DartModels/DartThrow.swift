//
//  DartThrow.swift
//
//  DartsScore
//  Created by Romero Peces Barba, Kevin on 30/4/23.
//

import Foundation

public enum DartThrow {
    case miss
    case hit(segment: TargetSegment, modifier: TargetSegmentModifier)

    public var value: Int {
        switch self {
        case .miss:
            return 0
        case let .hit(segment, modifier):
            return modifier.multiplier * segment.value
        }
    }
}
