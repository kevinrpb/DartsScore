//
//  Target.swift
//
//  DartsScore
//  Created by Romero Peces Barba, Kevin on 30/4/23.
//

import Foundation

// MARK: Models

public struct Target {
    public struct Segment: Equatable, Hashable {
        public enum Modifier: Int {
            case single = 1
            case double = 2
            case triple = 3
        }

        public let label: String
        public let value: Int

        private init(label: String, value: Int) {
            self.label = label
            self.value = value
        }
    }

    public let segments: [Segment]
}

public typealias TargetSegment = Target.Segment
public typealias TargetSegmentModifier = Target.Segment.Modifier

// MARK: Util values

public extension Target.Segment {
    var allowedModifiers: [Modifier] {
        switch self {
        case .bull: return [.single, .double]
        default: return [.single, .double, .triple]
        }
    }
}

public extension Target.Segment.Modifier {
    var multiplier: Int { rawValue }

    var labelPrefix: String {
        switch self {
        case .single: return ""
        case .double: return "D"
        case .triple: return "T"
        }
    }
}

// MARK: Default Target

public extension Target.Segment {
    static let bull: Target.Segment = .init(label: "Bull", value: 25)
    static let d1: Target.Segment = .init(label: "1", value: 1)
    static let d2: Target.Segment = .init(label: "2", value: 2)
    static let d3: Target.Segment = .init(label: "3", value: 3)
    static let d4: Target.Segment = .init(label: "4", value: 4)
    static let d5: Target.Segment = .init(label: "5", value: 5)
    static let d6: Target.Segment = .init(label: "6", value: 6)
    static let d7: Target.Segment = .init(label: "7", value: 7)
    static let d8: Target.Segment = .init(label: "8", value: 8)
    static let d9: Target.Segment = .init(label: "9", value: 9)
    static let d10: Target.Segment = .init(label: "10", value: 10)
    static let d11: Target.Segment = .init(label: "11", value: 11)
    static let d12: Target.Segment = .init(label: "12", value: 12)
    static let d13: Target.Segment = .init(label: "13", value: 13)
    static let d14: Target.Segment = .init(label: "14", value: 14)
    static let d15: Target.Segment = .init(label: "15", value: 15)
    static let d16: Target.Segment = .init(label: "16", value: 16)
    static let d17: Target.Segment = .init(label: "17", value: 17)
    static let d18: Target.Segment = .init(label: "18", value: 18)
    static let d19: Target.Segment = .init(label: "19", value: 19)
    static let d20: Target.Segment = .init(label: "20", value: 20)

    static let defaultSegments: [Target.Segment] = [
        bull,
        d1,
        d2,
        d3,
        d4,
        d5,
        d6,
        d7,
        d8,
        d9,
        d10,
        d11,
        d12,
        d13,
        d14,
        d15,
        d16,
        d17,
        d18,
        d19,
        d20,
    ]
}

public extension Collection<Target.Segment> {
    var bull: Target.Segment { .bull }
    var d1: Target.Segment { .d1 }
    var d2: Target.Segment { .d2 }
    var d3: Target.Segment { .d3 }
    var d4: Target.Segment { .d4 }
    var d5: Target.Segment { .d5 }
    var d6: Target.Segment { .d6 }
    var d7: Target.Segment { .d7 }
    var d8: Target.Segment { .d8 }
    var d9: Target.Segment { .d9 }
    var d10: Target.Segment { .d10 }
    var d11: Target.Segment { .d11 }
    var d12: Target.Segment { .d12 }
    var d13: Target.Segment { .d13 }
    var d14: Target.Segment { .d14 }
    var d15: Target.Segment { .d15 }
    var d16: Target.Segment { .d16 }
    var d17: Target.Segment { .d17 }
    var d18: Target.Segment { .d18 }
    var d19: Target.Segment { .d19 }
    var d20: Target.Segment { .d20 }
}

public extension Target {
    static let `default`: Target = .init(segments: Segment.defaultSegments)
}
