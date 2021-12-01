//
//  SensorCardView.swift
//  P2
//
//  Created by Noah Wilder on 2021-12-01.
//

import Foundation
import SwiftUI

struct SensorCardView: View {
    var title: String
    var level: String?
    var caption: String?
    var symbol: String
    @Binding
    var value: Int
    var minValue: Int
    var maxValue: Int
    var unit: String?
    
    var percent: CGFloat {
        return CGFloat(value - minValue) / CGFloat(maxValue - minValue)
    }
    
    var formattedValue: String {
        return unit == nil ? "\(value)" : "\(value) \(unit!)"
    }
    
    var formattedMinValue: String {
        return unit == nil ? "\(minValue)" : "\(minValue) \(unit!)"
        
    }
    
    var formattedMaxValue: String {
        return unit == nil ? "\(maxValue)" : "\(maxValue) \(unit!)"
        
    }
    
    var formattedLevel: String {
        return level == nil ? "" : " (\(level!))"
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12.5) {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: symbol)
                
                Text(title.uppercased())
                                    
                Spacer()
            }
            .font(.body.weight(.medium))
            .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(formattedValue)
                    .font(.system(.title, design: .rounded).bold())
                if let level = level {
                    Text(level)
                        .font(.headline)
                }
            }
            

            HStack {
                Text(formattedMinValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(formattedMaxValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
            }
            .padding(.bottom, -2.5)
            
            ProgressBar(
                height: 5,
                gradientColors: [.blue, .red],
                circleColor: .primary,
                backgroundColor: Color(UIColor.secondarySystemBackground),
                percent: percent
            )
            
            if let caption = caption {
                Text(caption)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
        }
    }
    
    
    
    
}
