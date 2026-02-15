//
//  HomePage.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import SwiftUI

struct HomePage: View {
    @ObservedObject var tab: BrowserTab

    private let quickLinks: [(String, String, String)] = [
        ("Google", "https://www.google.com", "magnifyingglass"),
        ("Wikipedia", "https://fr.wikipedia.org", "book.fill"),
        ("YouTube", "https://www.youtube.com", "play.rectangle.fill"),
        ("Apple", "https://www.apple.com", "apple.logo"),
    ]

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 40) {
                    Spacer(minLength: 60)

                    // Logo / titre
                    VStack(spacing: 12) {
                        Image(systemName: "globe")
                            .font(.system(size: 64))
                            .foregroundStyle(.tint)
                        Text("Navigateur pour Arthur")
                            .font(.title)
                            .fontWeight(.semibold)
                    }

                    // Liens rapides
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Accès rapide")
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 100, maximum: 160), spacing: 16)],
                            spacing: 16
                        ) {
                            ForEach(quickLinks, id: \.1) { name, urlString, icon in
                                Button {
                                    if let url = URL(string: urlString) {
                                        tab.loadURL(url)
                                    }
                                } label: {
                                    VStack(spacing: 8) {
                                        Image(systemName: icon)
                                            .font(.system(size: 24))
                                            .frame(width: 52, height: 52)
                                            .background(Color(.systemGray6))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))

                                        Text(name)
                                            .font(.caption)
                                            .foregroundStyle(.primary)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 40)

                    Spacer()
                }
            }
        }
    }
}
