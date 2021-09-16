//
//  ContentView.swift
//  BetterRest
//
//  Created by Евгений Кириллов on 14.09.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeUpTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var recomendation = "Your recomendation"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker(
                        "Please enter a time",
                        selection: $wakeUp,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                }
                
                Section(header: Text("Desired amount of sleep")) {
                    Stepper(
                        value: $sleepAmount,
                        in: 4...12,
                        step: 0.25
                    ) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(header: Text("Daily coffee intake")) {
                    Picker(
                        selection: $coffeeAmount,
                        label: Text("1 cup")
                    ) {
                        ForEach(1 ..< 21) {
                            if $0 == 1 {
                                Text("1 cup")
                            } else {
                                Text("\($0) cups")
                            }

                        }
                    }
                    .pickerStyle(InlinePickerStyle())
                }
                
                Section(header: Text("Recommended bedtime")) {
                    Text(recomendation)
                        .font(.title)
                }
            }
            .navigationBarTitle("Better rest")
            .onAppear {
                calculateBedtime()
            }
            .onChange(of: coffeeAmount) { _ in
                calculateBedtime()
            }
            .onChange(of: sleepAmount) { _ in
                calculateBedtime()
            }
            .onChange(of: wakeUp) { _ in
                calculateBedtime()
            }
        }
    }
    
    static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    private func calculateBedtime() {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(
                wake: Double(hour + minute),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount)
            )
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            recomendation = formatter.string(from: sleepTime)
        } catch {
            recomendation = "Sorry, there was a problem calculating your bedtime."
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
