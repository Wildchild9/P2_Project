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
    
    var body: some View {
        VStack() {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: symbol)
                
                Text(title.uppercased())
                
                Spacer()
            }
            .padding(.bottom, 10)
            
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
            
            Text(formattedValue)
                .font(.system(.largeTitle, design: .rounded).bold())
        }
        .padding()
    }
    
    
    
    
}
