//
//  ExerciseSettings.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import Foundation

enum ExerciseType: String, CaseIterable, Identifiable {
    case math = "Math"
    case lecture = "Lecture"
    case grammaire = "Grammaire"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .math: return "function"
        case .lecture: return "book.fill"
        case .grammaire: return "textformat.abc"
        }
    }
}

@MainActor
class ExerciseSettings: ObservableObject {
    @Published var intervalMinutes: Int = 5
    @Published var enabledExerciseTypes: Set<ExerciseType> = [.math, .lecture, .grammaire]

    func isEnabled(_ type: ExerciseType) -> Bool {
        enabledExerciseTypes.contains(type)
    }

    func toggle(_ type: ExerciseType) {
        if enabledExerciseTypes.contains(type) {
            if enabledExerciseTypes.count > 1 {
                enabledExerciseTypes.remove(type)
            }
        } else {
            enabledExerciseTypes.insert(type)
        }
    }
}
