//
//  HexagonBackground.swift
//  MatiasCamaron-Standalone
//
//  Created by Matias Martinez on 28/01/24.
//

import SwiftUI

struct HexagonBackground: View {
    var body: some View {
        
        GeometryReader { geometry in
            Path { path in
                var width: CGFloat = min(geometry.size.width*1.2, geometry.size.height*1.2)
                let height = width*1.1
                let xScale: CGFloat = 0.8
                let xOffset = (width * (1.0 - xScale)) / 2.0
                width *= xScale
                path.move(
                    to: CGPoint(
                        x: width * 0.95 + xOffset,
                        y: height * (0.20 + HexagonParameters.adjustment)
                    )
                )
                HexagonParameters.segments.forEach { segment in
                    path.addLine(
                        to: CGPoint(
                            x: width * segment.line.x + xOffset,
                            y: height * segment.line.y
                        )
                    )
                    path.addQuadCurve(
                        to: CGPoint(
                            x: width * segment.curve.x + xOffset,
                            y: height * segment.curve.y
                        ),
                        control: CGPoint(
                            x: width * segment.control.x + xOffset,
                            y: height * segment.control.y
                        )
                    )
                }
            }
            .fill(.linearGradient(
                Gradient(colors: [Self.gradientStart, Self.gradientEnd]),
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 0.6)
            ))
        }
    }
    static let gradientStart = Color(red: 93 / 255, green: 63 / 255, blue: 211 / 255)
    static let gradientEnd = Color(red: 115.0 / 255, green: 147.0 / 255, blue: 179.0 / 255)
}

#Preview {
    HexagonBackground()
}
