//
//  BrowserView.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import SwiftUI

struct BrowserView: View {
    @StateObject private var viewModel = BrowserViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Barre d'onglets
            TabBar(viewModel: viewModel)

            Divider()

            // Toolbar avec barre d'adresse
            ToolbarView(viewModel: viewModel)

            Divider()

            // Contenu principal
            ZStack {
                // Pages web empilées
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
    }
}
