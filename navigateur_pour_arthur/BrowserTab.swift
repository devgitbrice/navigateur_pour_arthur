//
//  BrowserTab.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import Foundation
import WebKit
import Combine

@MainActor
class BrowserTab: ObservableObject, Identifiable {
    let id = UUID()
    @Published var url: URL?
    @Published var title: String = "Nouvel onglet"
    @Published var isLoading: Bool = false
    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false
    @Published var estimatedProgress: Double = 0
    @Published var favicon: Data?

    let webView: WKWebView

    init(url: URL? = nil) {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        self.webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView.allowsBackForwardNavigationGestures = true

        if let url = url {
            self.url = url
            self.webView.load(URLRequest(url: url))
        }
    }

    func loadURL(_ url: URL) {
        self.url = url
        webView.load(URLRequest(url: url))
    }

    func loadURLString(_ string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)

        if let url = URL(string: trimmed), url.scheme != nil,
           trimmed.contains(".") {
            loadURL(url)
        } else if let url = URL(string: "https://\(trimmed)"),
                  trimmed.contains(".") {
            loadURL(url)
        } else {
            let query = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? trimmed
            if let searchURL = URL(string: "https://www.google.com/search?q=\(query)") {
                loadURL(searchURL)
            }
        }
    }

    func goBack() {
        webView.goBack()
    }

    func goForward() {
        webView.goForward()
    }

    func reload() {
        webView.reload()
    }

    func stopLoading() {
        webView.stopLoading()
    }
}
