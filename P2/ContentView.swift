//
//  ContentView.swift
//  P2
//
//  Created by Noah Wilder on 2021-11-09.
//

import SwiftUI
import Firebase
import UserNotifications

struct ContentView: View {
    
    @AppStorage("co2") var concentration: Int = 0
    @AppStorage("temperature") var temperature: Int = 0
    @AppStorage("sound") var soundLevel: Int = 0
    
    @Environment(\.colorScheme) var colorScheme
    
    var cardBackgroundColor: Color {
        return colorScheme == .light ? .white : Color(UIColor.secondarySystemFill)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                
                SensorCardView(
                    title: "CO₂ Levels",
                    symbol: AirQuality.low.symbolName,
                    value: $concentration,
                    minValue: 0,
                    maxValue: 2000,
                    unit: "PPM"
                )
                .padding(.top, 10)
                
                SensorCardView(
                    title: "Temperature",
                    symbol: "thermometer",
                    value: $temperature,
                    minValue: 0,
                    maxValue: 100,
                    unit: "°C"
                )
                
                SensorCardView(
                    title: "Sound Levels",
                    symbol: "ear",
                    value: $soundLevel,
                    minValue: 0,
                    maxValue: 200,
                    unit: "dB"
                )
                
                Spacer()
                
            }
            .onAppear {
                
                setUpObservers()
            }
            .navigationTitle("Productivity Metrics")
            
        }
    }
    
    func setUpObserver<T>(for childKey: String, valueType: T.Type, onValueChanged: @escaping (T) -> Void)  {
        Database.database().reference().child(childKey).observe(.value) { snapshot in
            guard let newValue = snapshot.value as? T else {
                print("Could not parse value.")
                return
            }
            onValueChanged(newValue)
        }
    }
    
    func setUpObservers() {
        setUpObserver(for: "co2", valueType: Int.self) { newConcentration in
            guard newConcentration != concentration else { return }
            dispatchNotification(title: "CO₂ levels updated", message: "The new CO₂ level is \(newConcentration) PPM")
            withAnimation {
                concentration = newConcentration
            }
        }
        setUpObserver(for: "temperature", valueType: Int.self) { newTemperature in
            guard newTemperature != temperature else { return }
            withAnimation {
                temperature = newTemperature
            }
        }
        setUpObserver(for: "sound", valueType: Int.self) { newSoundLevel in
            guard newSoundLevel != soundLevel else { return }
//            UserDefaults.standard.set(newSoundLevel, forKey: "sound")
            withAnimation {
                soundLevel = newSoundLevel
            }
        }
    }
    
    func dispatchNotification(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = message
        content.sound = UNNotificationSound.default
        
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}


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

enum AirQuality {
    case low
    case medium
    case high
    
    
    var symbolName: String {
        switch self {
        case .low: return "aqi.low"
        case .medium: return "aqi.medium"
        case .high: return "aqi.high"
        }
    }
}
struct ProgressBar: View {
    var height: CGFloat
    var gradientColors: [Color]
    var circleColor: Color
    var backgroundColor: Color
   // @Binding var percent: CGFloat
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
