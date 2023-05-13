//
//  Shape+Fill.swift
//  DartsScore
//
//  Created by Romero Peces Barba, Kevin on 6/5/23.
//

import SwiftUI

extension Shape {
    func fill(
        _ fillStyle: some ShapeStyle,
        strokeBorder strokeStyle: some ShapeStyle,
        lineWidth: Double = 1
    ) -> some View {
        stroke(strokeStyle, lineWidth: lineWidth)
            .background(fill(fillStyle))
    }
}

extension InsettableShape {
    func fill(
        _ fillStyle: some ShapeStyle,
        strokeBorder strokeStyle: some ShapeStyle,
        lineWidth: Double = 1
    ) -> some View {
        strokeBorder(strokeStyle, lineWidth: lineWidth)
            .background(fill(fillStyle))
    }
}
