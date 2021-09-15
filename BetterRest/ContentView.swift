//
//  ContentView.swift
//  BetterRest
//
//  Created by Евгений Кириллов on 14.09.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date()
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want to wake up?")
                DatePicker(
                    "Please enter a time",
                    selection: $wakeUp,
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
                Text("Desired amount of sleep")
                Stepper(
                    value: $sleepAmount,
                    in: 4...12,
                    step: 0.25
                ) {
                    Text("\(sleepAmount, specifier: "%g") hours")
                }
                Text("Daily coffee intake")
                Stepper(value: $coffeeAmount, in: 1...20) {
                    if coffeeAmount == 1 {
                        Text("1 cup")
                    } else {
                        Text("\(coffeeAmount) cups")
                    }
                }
            }
            .font(.headline)
            .navigationBarTitle("Better rest")
            .navigationBarItems(
                trailing: Button(action: calculateBedtime) {
                    Text("Calculate")
                }
            )
        }
    }
    
    private func calculateBedtime() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
