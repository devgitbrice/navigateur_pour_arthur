//
//  BrowserView.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import SwiftUI

struct BrowserView: View {
    @StateObject private var viewModel = BrowserViewModel()

    let userMode: UserMode
    @ObservedObject var exerciseSettings: ExerciseSettings
    @ObservedObject var exerciseManager: ExerciseManager

    @State private var showSettings = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Barre d'onglets
                TabBar(viewModel: viewModel)

                Divider()

                // Toolbar avec barre d'adresse
                HStack(spacing: 0) {
                    ToolbarView(viewModel: viewModel)
                        .frame(maxWidth: .infinity)

                    // Bouton Parametres pour les adultes
                    if userMode == .adulte {
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 18))
                                .padding(.trailing, 12)
                        }
                    }
                }

                Divider()

                // Contenu principal
                ZStack {
                    // Pages web empilees
                    ForEach(Array(viewModel.tabs.enumerated()), id: \.element.id) { index, tab in
                        WebView(webView: tab.webView, tab: tab)
                            .opacity(index == viewModel.activeTabIndex ? 1 : 0)
                            .allowsHitTesting(index == viewModel.activeTabIndex)
                    }

                    // Grille d'onglets
                    if viewModel.showTabGrid {
                        TabGridView(viewModel: viewModel)
                            .transition(.opacity)
                    }

                    // Page d'accueil si pas d'URL
                    if let tab = viewModel.activeTab, tab.url == nil, !viewModel.showTabGrid {
                        HomePage(tab: tab)
                            .transition(.opacity)
                    }
                }
            }
            .ignoresSafeArea(.keyboard)

            // Overlay exercice
            if exerciseManager.showExercise, let exercise = exerciseManager.currentExercise {
                ExerciseSessionView(exercise: exercise) {
                    exerciseManager.completeCurrentExercise()
                }
                .transition(.opacity)
                .zIndex(100)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(settings: exerciseSettings, exerciseManager: exerciseManager)
        }
    }
}
