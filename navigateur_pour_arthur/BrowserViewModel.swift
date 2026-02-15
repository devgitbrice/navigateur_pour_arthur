//
//  BrowserViewModel.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import Foundation
import Combine

@MainActor
class BrowserViewModel: ObservableObject {
    @Published var tabs: [BrowserTab] = []
    @Published var activeTabIndex: Int = 0
    @Published var showTabGrid: Bool = false

    var activeTab: BrowserTab? {
        guard !tabs.isEmpty, activeTabIndex >= 0, activeTabIndex < tabs.count else {
            return nil
        }
        return tabs[activeTabIndex]
    }

    init() {
        addNewTab()
    }

    func addNewTab(url: URL? = nil) {
        let tab = BrowserTab(url: url)
        tabs.append(tab)
        activeTabIndex = tabs.count - 1
        showTabGrid = false
    }

    func closeTab(at index: Int) {
        guard index >= 0, index < tabs.count else { return }
        tabs.remove(at: index)

        if tabs.isEmpty {
            addNewTab()
        } else if activeTabIndex >= tabs.count {
            activeTabIndex = tabs.count - 1
        }
    }

    func closeTab(id: UUID) {
        if let index = tabs.firstIndex(where: { $0.id == id }) {
            closeTab(at: index)
        }
    }

    func selectTab(at index: Int) {
        guard index >= 0, index < tabs.count else { return }
        activeTabIndex = index
        showTabGrid = false
    }

    func selectTab(id: UUID) {
        if let index = tabs.firstIndex(where: { $0.id == id }) {
            selectTab(at: index)
        }
    }
}
