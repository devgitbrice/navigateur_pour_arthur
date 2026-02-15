//
//  WelcomeView.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import SwiftUI

enum UserMode {
    case enfant
    case adulte
}

struct WelcomeView: View {
    @Binding var userMode: UserMode?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                Image(systemName: "globe")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue)

                Text("Navigateur pour Arthur")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Qui es-tu ?")
                    .font(.title2)
                    .foregroundStyle(.secondary)

                HStack(spacing: 30) {
                    Button {
                        withAnimation {
                            userMode = .enfant
                        }
                    } label: {
                        VStack(spacing: 16) {
                            Image(systemName: "figure.child")
                                .font(.system(size: 48))
                            Text("Enfant")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .frame(width: 180, height: 180)
                        .background(Color.green.opacity(0.2))
                        .foregroundStyle(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.green, lineWidth: 2)
                        )
                    }

                    Button {
                        withAnimation {
                            userMode = .adulte
                        }
                    } label: {
                        VStack(spacing: 16) {
                            Image(systemName: "figure.stand")
                                .font(.system(size: 48))
                            Text("Adulte")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .frame(width: 180, height: 180)
                        .background(Color.blue.opacity(0.2))
                        .foregroundStyle(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                    }
                }

                Spacer()
            }
        }
    }
}
