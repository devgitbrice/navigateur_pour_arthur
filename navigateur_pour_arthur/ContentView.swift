//
//  ContentView.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var userMode: UserMode?
    @State private var exerciseSettings = ExerciseSettings()
    @State private var exerciseManager: ExerciseManager?

    var body: some View {
        Group {
            if let mode = userMode, let manager = exerciseManager {
                BrowserView(
                    userMode: mode,
                    exerciseSettings: exerciseSettings,
                    exerciseManager: manager
                )
            } else {
                WelcomeView(userMode: $userMode)
            }
        }
        .onChange(of: userMode) { _, newMode in
            if newMode != nil {
                let manager = ExerciseManager(settings: exerciseSettings)
                exerciseManager = manager
                manager.startTimer()
            }
        }
    }
}

#Preview {
    ContentView()
}
