//
//  Hexagon.swift
//  firebase-backed
//
//  Created by keckuser on 3/19/24.
//

import CoreGraphics

import SwiftUI


struct ShapeParameters {
    struct Segment {
        let line: CGPoint
        let curve: CGPoint
        let control: CGPoint
    }
    
    static let adjustment: CGFloat = 0.085
    
    
    static let segments = [
        Segment(
            line:    CGPoint(x: 2 - 0.25, y: 3),
            curve:   CGPoint(x: 1 - 0.25, y: 1),
            control: CGPoint(x: 0 - 0.25, y: 1)
        ),
        Segment(
            line:    CGPoint(x: 2 - 0.25, y: 1),
            curve:   CGPoint(x: 1 - 0.25, y: 3),
            control: CGPoint(x: 2 - 0.25, y: 1)
        ),
        
        //        Hexagon:
        //        Segment(
        //            line:    CGPoint(x: 0.05, y: 0.20 + adjustment),
        //            curve:   CGPoint(x: 0.00, y: 0.30 + adjustment),
        //            control: CGPoint(x: 0.00, y: 0.25 + adjustment)
        //        ),
        //        Segment(
        //            line:    CGPoint(x: 0.00, y: 0.70 - adjustment),
        //            curve:   CGPoint(x: 0.05, y: 0.80 - adjustment),
        //            control: CGPoint(x: 0.00, y: 0.75 - adjustment)
        //        ),
        //        Segment(
        //            line:    CGPoint(x: 0.40, y: 0.95),
        //            curve:   CGPoint(x: 0.60, y: 0.95),
        //            control: CGPoint(x: 0.50, y: 1.00)
        //        ),
        //        Segment(
        //            line:    CGPoint(x: 0.95, y: 0.80 - adjustment),
        //            curve:   CGPoint(x: 1.00, y: 0.70 - adjustment),
        //            control: CGPoint(x: 1.00, y: 0.75 - adjustment)
        //        ),
        //        Segment(
        //            line:    CGPoint(x: 1.00, y: 0.30 + adjustment),
        //            curve:   CGPoint(x: 0.95, y: 0.20 + adjustment),
        //            control: CGPoint(x: 1.00, y: 0.25 + adjustment)
        //        )
    ]
}

struct BadgeBackground: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                var width: CGFloat = min(geometry.size.width, geometry.size.height)
                var height = width
                let xScale: CGFloat = 0.4
                let yScale: CGFloat = 0.2
                let xOffset = -95 + (width * (1.0 - xScale)) / 2
                width *= xScale
                height *= yScale
                path.move(
                    to: CGPoint(
                        x: width * 0.95 + xOffset,
                        y: height * (0.20 + ShapeParameters.adjustment)
                    )
                )
                
                ShapeParameters.segments.forEach { segment in
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
                startPoint: UnitPoint(x: 0.25, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 0.6)
            ))
        }
        .aspectRatio(1, contentMode: .fit)
    }
    static let gradientStart = Color(red: 1, green: 0.2, blue: 0.128)
    static let gradientEnd = Color(red: 0.44, green: -0.051, blue: 0.5)
}


#Preview {
    BadgeBackground()
}
