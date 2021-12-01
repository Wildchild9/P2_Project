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
    
    @AppStorage("temperature") var temperature: Int = 0
    @AppStorage("sound") var soundLevel: Int = 0
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var co2Level: CO2Level {
        willSet {
            UserDefaults.standard.set(newValue.concentration, forKey: "co2")
        }
    }
    
    var cardBackgroundColor: Color {
        return colorScheme == .light ? .white : Color(UIColor.secondarySystemFill)
    }
    
    init() {
        _co2Level = State(wrappedValue: CO2Level(concentration: UserDefaults.standard.integer(forKey: "co2")))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                
                VStack {
                    SensorCardView(
                        title: "CO₂ Levels",
                        symbol: co2Level.symbolName,
                        value: $co2Level.concentration,
                        minValue: 0,
                        maxValue: 5000,
                        unit: "PPM"
                    )
                    Text("\(co2Level.hazardLevel.caption)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
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
            guard newConcentration != co2Level.concentration else { return }
            let newCO2Level = CO2Level(concentration: newConcentration)
            
            if co2Level.hazardLevel != newCO2Level.hazardLevel && newCO2Level.hazardLevel.requiresNotification {
                let (title, message) = newCO2Level.hazardLevel.notificationContent
                dispatchNotification(title: title, message: message)
            }
            withAnimation {
                co2Level = newCO2Level
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



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
