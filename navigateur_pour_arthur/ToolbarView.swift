//
//  ToolbarView.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import SwiftUI

struct ToolbarView: View {
    @ObservedObject var viewModel: BrowserViewModel

    var body: some View {
        if let tab = viewModel.activeTab {
            HStack(spacing: 16) {
                // Navigation arrière
                Button {
                    tab.goBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                }
                .disabled(!tab.canGoBack)

                // Navigation avant
                Button {
                    tab.goForward()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .medium))
                }
                .disabled(!tab.canGoForward)

                // Barre d'adresse
                AddressBar(tab: tab)
                    .frame(maxWidth: .infinity)

                // Bouton grille d'onglets
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        viewModel.showTabGrid.toggle()
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(lineWidth: 1.5)
                            .frame(width: 20, height: 20)
                        Text("\(viewModel.tabs.count)")
                            .font(.system(size: 12, weight: .bold))
                    }
                }

                // Menu partage / plus
                Menu {
                    if let url = tab.url {
                        Button {
                            UIPasteboard.general.url = url
                        } label: {
                            Label("Copier le lien", systemImage: "doc.on.doc")
                        }
                    }

                    Button {
                        tab.reload()
                    } label: {
                        Label("Recharger", systemImage: "arrow.clockwise")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 18))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            // Barre de progression
            if tab.isLoading {
                ProgressView(value: tab.estimatedProgress)
                    .progressViewStyle(.linear)
                    .tint(.blue)
            }
        }
    }
}
