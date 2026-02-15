//
//  ExerciseSessionView.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import SwiftUI

struct ExerciseSessionView: View {
    let exercise: Exercise
    let onComplete: () -> Void

    @State private var hasScrolledToBottom = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // En-tete
                HStack {
                    Image(systemName: "book.fill")
                        .font(.title2)
                        .foregroundStyle(.yellow)

                    Text("Temps d'exercice !")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    Spacer()

                    Label(exercise.type.rawValue, systemImage: exercise.type.icon)
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())
                        .foregroundStyle(.white)
                }
                .padding()
                .background(Color.blue.opacity(0.8))

                // Titre de l'article
                Text(exercise.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .padding(.top, 24)
                    .padding(.horizontal)

                Divider()
                    .padding(.horizontal)
                    .padding(.vertical, 8)

                // Contenu de l'article
                ScrollView {
                    Text(exercise.content)
                        .font(.body)
                        .lineSpacing(6)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)

                    // Detecteur de fin de scroll
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                hasScrolledToBottom = true
                            }
                    }
                    .frame(height: 1)
                }
                .background(Color(.systemBackground))

                // Bouton OK
                VStack(spacing: 8) {
                    if !hasScrolledToBottom {
                        Text("Lis l'article jusqu'au bout !")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Button {
                        onComplete()
                    } label: {
                        Text("J'ai termine !")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(hasScrolledToBottom ? Color.green : Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!hasScrolledToBottom)
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(24)
            .shadow(radius: 20)
        }
    }
}
