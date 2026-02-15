//
//  WebView.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let webView: WKWebView
    @ObservedObject var tab: BrowserTab

    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Updates are driven by tab actions, not SwiftUI state
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(tab: tab)
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        let tab: BrowserTab
        private var progressObservation: NSKeyValueObservation?
        private var titleObservation: NSKeyValueObservation?
        private var urlObservation: NSKeyValueObservation?
        private var canGoBackObservation: NSKeyValueObservation?
        private var canGoForwardObservation: NSKeyValueObservation?

        init(tab: BrowserTab) {
            self.tab = tab
            super.init()
            setupObservers()
        }

        private func setupObservers() {
            progressObservation = tab.webView.observe(\.estimatedProgress) { [weak self] webView, _ in
                Task { @MainActor in
                    self?.tab.estimatedProgress = webView.estimatedProgress
                }
            }

            titleObservation = tab.webView.observe(\.title) { [weak self] webView, _ in
                Task { @MainActor in
                    if let title = webView.title, !title.isEmpty {
                        self?.tab.title = title
                    }
                }
            }

            urlObservation = tab.webView.observe(\.url) { [weak self] webView, _ in
                Task { @MainActor in
                    self?.tab.url = webView.url
                }
            }

            canGoBackObservation = tab.webView.observe(\.canGoBack) { [weak self] webView, _ in
                Task { @MainActor in
                    self?.tab.canGoBack = webView.canGoBack
                }
            }

            canGoForwardObservation = tab.webView.observe(\.canGoForward) { [weak self] webView, _ in
                Task { @MainActor in
                    self?.tab.canGoForward = webView.canGoForward
                }
            }
        }

        // MARK: - WKNavigationDelegate

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            Task { @MainActor in
                tab.isLoading = true
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            Task { @MainActor in
                tab.isLoading = false
            }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            Task { @MainActor in
                tab.isLoading = false
            }
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            Task { @MainActor in
                tab.isLoading = false
            }
        }

        // MARK: - WKUIDelegate

        func webView(
            _ webView: WKWebView,
            createWebViewWith configuration: WKWebViewConfiguration,
            for navigationAction: WKNavigationAction,
            windowFeatures: WKWindowFeatures
        ) -> WKWebView? {
            // Open links that want a new window in the current tab
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
    }
}
