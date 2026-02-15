//
//  TabBar.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import SwiftUI

struct TabBar: View {
    @ObservedObject var viewModel: BrowserViewModel

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 2) {
                    ForEach(Array(viewModel.tabs.enumerated()), id: \.element.id) { index, tab in
                        TabBarItem(
                            tab: tab,
                            isActive: index == viewModel.activeTabIndex,
                            onSelect: {
                                viewModel.selectTab(at: index)
                            },
                            onClose: {
                                viewModel.closeTab(at: index)
                            }
                        )
                        .id(tab.id)
                    }

                    // Bouton nouvel onglet
                    Button {
                        viewModel.addNewTab()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.primary)
                            .frame(width: 32, height: 32)
                    }
                }
                .padding(.horizontal, 8)
            }
            .onChange(of: viewModel.activeTabIndex, perform: { _ in
                if let tab = viewModel.activeTab {
                    withAnimation {
                        proxy.scrollTo(tab.id, anchor: .center)
                    }
                }
            })
        }
        .frame(height: 36)
        .background(Color(.systemGray5))
    }
}

struct TabBarItem: View {
    @ObservedObject var tab: BrowserTab
    let isActive: Bool
    let onSelect: () -> Void
    let onClose: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            Text(tab.title)
                .font(.system(size: 12))
                .lineLimit(1)
                .frame(maxWidth: 140)

            Button {
                onClose()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(isActive ? Color(.systemBackground) : Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .onTapGesture {
            onSelect()
        }
    }
}
