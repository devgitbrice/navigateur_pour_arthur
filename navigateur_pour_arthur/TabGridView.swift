//
//  TabGridView.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import SwiftUI

struct TabGridView: View {
    @ObservedObject var viewModel: BrowserViewModel

    private let columns = [
        GridItem(.adaptive(minimum: 200, maximum: 280), spacing: 16)
    ]

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack {
                // En-tête
                HStack {
                    Text("\(viewModel.tabs.count) onglet\(viewModel.tabs.count > 1 ? "s" : "")")
                        .font(.headline)

                    Spacer()

                    Button("OK") {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            viewModel.showTabGrid = false
                        }
                    }
                    .fontWeight(.semibold)
                }
                .padding()

                // Grille d'onglets
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Array(viewModel.tabs.enumerated()), id: \.element.id) { index, tab in
                            TabGridItem(
                                tab: tab,
                                isActive: index == viewModel.activeTabIndex,
                                onSelect: {
                                    viewModel.selectTab(at: index)
                                },
                                onClose: {
                                    withAnimation {
                                        viewModel.closeTab(at: index)
                                    }
                                }
                            )
                        }
                    }
                    .padding()
                }

                // Bouton nouvel onglet
                HStack {
                    Spacer()
                    Button {
                        viewModel.addNewTab()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .medium))
                            .padding()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct TabGridItem: View {
    @ObservedObject var tab: BrowserTab
    let isActive: Bool
    let onSelect: () -> Void
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // En-tête avec titre et bouton fermer
            HStack {
                Text(tab.title)
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundStyle(.primary)

                Spacer()

                Button {
                    onClose()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.secondary)
                        .padding(4)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(isActive ? Color.accentColor.opacity(0.15) : Color(.systemGray5))

            // Aperçu (placeholder)
            ZStack {
                Color(.systemGray6)

                if tab.url != nil {
                    VStack(spacing: 8) {
                        Image(systemName: "globe")
                            .font(.system(size: 32))
                            .foregroundStyle(.tertiary)
                        if let host = tab.url?.host {
                            Text(host)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "square.grid.2x2")
                            .font(.system(size: 32))
                            .foregroundStyle(.tertiary)
                        Text("Nouvel onglet")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(height: 160)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isActive ? Color.accentColor : Color(.systemGray4), lineWidth: isActive ? 2 : 0.5)
        )
        .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
        .onTapGesture {
            onSelect()
        }
    }
}
