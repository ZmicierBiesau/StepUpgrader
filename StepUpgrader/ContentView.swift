//
//  ContentView.swift
//  StepUpgrader
//
//  Created by Dzmitryj Biesau on 14/05/2024.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    private var healthStore: HealthStore?
    @State private var stepsToAdd: String = ""
    @State private var startDate: Date = Date()
    @State private var alertPresented = false
    
    init() {
        healthStore = HealthStore()
    }
    
    var body: some View {
        let convertedSteps = Double(stepsToAdd) ?? 0.0
        let isDisabled = stepsToAdd == "" || convertedSteps == 0.0
        
        NavigationView {
            Form {
                Section {
                    DatePicker("Start Time", selection: $startDate)
                        .datePickerStyle(.compact)
                    TextField("Amount of steps", text: $stepsToAdd)
                        .keyboardType(.decimalPad)
                        .frame(height: 100)
                        .font(.system(size: 24, weight: .semibold, design: .default))
                    
                } footer: {
                    Text("Duration for your \"walk\" will be 1 hour ")
                        .foregroundStyle(.gray)
                }
               
                HStack {
                    Button("Write Steps", action: {
                        if let healthStore = healthStore {
                            healthStore.requestAuthorization { success in
                                if success {
                                    healthStore.writeSteps(startDate: startDate, stepsToAdd: convertedSteps)
                                    self.alertPresented.toggle()
                                    self.stepsToAdd = ""
                                }
                            }
                            
                        }
                    })
                    .frame(height: 60)
                    .foregroundColor(.blue)
                    .disabled(isDisabled)
                    .alert(isPresented: $alertPresented, content: {
                        Alert(title: Text("Success"), message: Text("Successfully added \(stepsToAdd) steps to Health data"), dismissButton: .default(Text("Dismiss")))
                    })
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    LinearGradient(
                        colors: [.red, .yellow, .orange, .green, .blue, .indigo, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(
                        Text("Step Upgrader")
                            .font(Font.system(size: 46, weight: .bold))
                            .multilineTextAlignment(.center)
                    )
                    .padding(.top, 20)
                    .frame(height: 100)
                }
            }
        }
    }
}
