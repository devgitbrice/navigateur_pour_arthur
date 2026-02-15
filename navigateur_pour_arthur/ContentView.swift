//
//  ContentView.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var userMode: UserMode?
    @StateObject private var exerciseSettings = ExerciseSettings()
    @StateObject private var exerciseManager: ExerciseManager

    init() {
        let settings = ExerciseSettings()
        _exerciseSettings = StateObject(wrappedValue: settings)
        _exerciseManager = StateObject(wrappedValue: ExerciseManager(settings: settings))
    }

    var body: some View {
        Group {
            if let mode = userMode {
                BrowserView(
                    userMode: mode,
                    exerciseSettings: exerciseSettings,
                    exerciseManager: exerciseManager
                )
            } else {
                WelcomeView(userMode: $userMode)
            }
        }
        .onChange(of: userMode) { newMode in
            if newMode != nil {
                exerciseManager.startTimer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
