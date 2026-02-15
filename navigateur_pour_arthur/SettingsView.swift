//
//  SettingsView.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: ExerciseSettings
    @ObservedObject var exerciseManager: ExerciseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Stepper(
                        "Duree entre les exercices : \(settings.intervalMinutes) min",
                        value: $settings.intervalMinutes,
                        in: 1...60
                    )
                } header: {
                    Text("Minuterie")
                }

                Section {
                    ForEach(ExerciseType.allCases) { type in
                        Toggle(isOn: Binding(
                            get: { settings.isEnabled(type) },
                            set: { _ in settings.toggle(type) }
                        )) {
                            Label(type.rawValue, systemImage: type.icon)
                        }
                    }
                } header: {
                    Text("Exercices actives")
                } footer: {
                    Text("Au moins un type d'exercice doit rester active.")
                }

                Section {
                    Button("Lancer un exercice maintenant") {
                        dismiss()
                        Task {
                            try? await Task.sleep(nanoseconds: 300_000_000)
                            exerciseManager.triggerExercise()
                        }
                    }
                }
            }
            .navigationTitle("Parametres")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("OK") {
                        exerciseManager.restartTimer()
                        dismiss()
                    }
                }
            }
        }
    }
}
