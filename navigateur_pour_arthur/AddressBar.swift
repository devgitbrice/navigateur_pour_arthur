//
//  AddressBar.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import SwiftUI

struct AddressBar: View {
    @ObservedObject var tab: BrowserTab
    @State private var addressText: String = ""
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            // Icone de sécurité
            if let url = tab.url, url.scheme == "https" {
                Image(systemName: "lock.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            TextField("Rechercher ou saisir une adresse", text: $addressText)
                .textFieldStyle(.plain)
                .font(.system(size: 15))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(.webSearch)
                .focused($isFocused)
                .onSubmit {
                    tab.loadURLString(addressText)
                    isFocused = false
                }
                .onChange(of: isFocused) { focused in
                    if focused {
                        isEditing = true
                        addressText = tab.url?.absoluteString ?? ""
                    } else {
                        isEditing = false
                        updateDisplayText()
                    }
                }

            // Bouton effacer
            if isEditing && !addressText.isEmpty {
                Button {
                    addressText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }

            // Indicateur de rechargement / arrêt
            if tab.isLoading {
                Button {
                    tab.stopLoading()
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else if !isEditing {
                Button {
                    tab.reload()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onAppear {
            updateDisplayText()
        }
        .onChange(of: tab.url) { _ in
            if !isEditing {
                updateDisplayText()
            }
        }
    }

    private func updateDisplayText() {
        if let url = tab.url {
            addressText = url.host ?? url.absoluteString
        } else {
            addressText = ""
        }
    }
}
