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
    
    @State var co2Level: CO2Level {
        willSet {
            UserDefaults.standard.set(newValue.concentration, forKey: "co2")
        }
    }
    @State var temperatureLevel: TemperatureLevel {
        willSet {
            UserDefaults.standard.set(newValue.temperature, forKey: "temperature")
        }
    }
    @AppStorage("sound") var soundLevel: Int = 0

    
    @Environment(\.colorScheme) var colorScheme
    
    
    
    var cardBackgroundColor: Color {
        return colorScheme == .light ? .white : Color(UIColor.secondarySystemFill)
    }
    
    init() {
        _co2Level = State(wrappedValue: CO2Level(concentration: UserDefaults.standard.integer(forKey: "co2")))
        _temperatureLevel = State(wrappedValue: TemperatureLevel(temperature: UserDefaults.standard.integer(forKey: "temperature")))
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(spacing: 25) {
                    
                    VStack {
                        SensorCardView(
                            title: "CO₂ Levels",
                            level: co2Level.hazardLevel.name,
                            caption: co2Level.caption,
                            symbol: co2Level.symbolName,
                            value: $co2Level.concentration,
                            minValue: 0,
                            maxValue: 5000,
                            unit: "PPM"
                        )
                        
                    }
                    Divider()
                    SensorCardView(
                        title: "Temperature",
                        level: temperatureLevel.hazardLevel.name,
                        caption: temperatureLevel.caption,
                        symbol: temperatureLevel.symbolName,
                        value: $temperatureLevel.temperature,
                        minValue: 0,
                        maxValue: 50,
                        unit: "°C"
                    )
                    
                    Divider()
                    
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
                .padding()
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
            
            if co2Level.hazardLevel != newCO2Level.hazardLevel && newCO2Level.requiresNotification {
                let (title, _) = newCO2Level.notificationContent
                dispatchNotification(title: title, message: "See app for more details.")
            }
            withAnimation {
                co2Level = newCO2Level
            }
        }
        setUpObserver(for: "temperature", valueType: Int.self) { newTemperature in
            guard newTemperature != temperatureLevel.temperature else { return }
            let newTemperatureLevel = TemperatureLevel(temperature: newTemperature)
            
            if temperatureLevel.hazardLevel != newTemperatureLevel.hazardLevel && newTemperatureLevel.requiresNotification {
                let (title, _) = newTemperatureLevel.notificationContent
                dispatchNotification(title: title, message: "See app for more details.")
            }
            withAnimation {
                temperatureLevel = newTemperatureLevel
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
