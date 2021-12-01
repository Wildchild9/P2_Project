//
//  ProgressBar.swift
//  P2
//
//  Created by Noah Wilder on 2021-12-01.
//

import Foundation
import SwiftUI

struct ProgressBar: View {
    var height: CGFloat
    var gradientColors: [Color]
    var circleColor: Color
    var backgroundColor: Color
    var percent: CGFloat
    
    var clampedPercent: CGFloat {
        return max(0, min(1, percent))
    }
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(backgroundColor)
                .frame(height: height)
            
            ProgressBarShape(percent: clampedPercent)
                .fill(LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .leading, endPoint: .trailing))
                .frame(height: height)
                .overlay(
                    ProgressBarCircleShape(percent: clampedPercent)
                        .fill(circleColor)//.opacity(0.5))
                )
            //                .animation(.default)
        }
    }
}
struct ProgressBarShape: Shape {
    var percent: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var rect = rect
        rect.size.width *= percent
        return Path(roundedRect: rect, cornerRadius: rect.height / 2)
    }
    
    var animatableData: CGFloat {
        get { percent }
        set { self.percent = newValue }
    }
}

struct ProgressBarCircleShape: Shape {
    var percent: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var rect = rect
        rect.size.width -= rect.height
        
        let diameter = rect.height * 2
        let x = rect.origin.x - rect.height / 2 + rect.width * percent
        let y = rect.origin.y - rect.height / 2
        
        return Circle().path(in: CGRect(x: x, y: y, width: diameter, height: diameter))
    }
    
    var animatableData: CGFloat {
        get { percent }
        set { self.percent = newValue }
    }
}

struct Slider: View {
    var minValue: String
    var maxValue: String
    var scale: Range<Double>
    @Binding var value: Double
    
    var body: some View {
        HStack {
            Text(minValue)
            Capsule()
            Text(maxValue)
        }
    }
    
}

