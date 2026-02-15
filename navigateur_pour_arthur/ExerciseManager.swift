//
//  ExerciseManager.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import Foundation
import Combine

struct Exercise: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let type: ExerciseType
}

class ExerciseManager: ObservableObject {
    @Published var showExercise: Bool = false
    @Published var currentExercise: Exercise?
    @Published var currentExerciseIndex: Int = 0

    private var timerTask: Task<Void, Never>?
    private let settings: ExerciseSettings

    let exerciseQueue: [Exercise]

    static let predefinedArticles: [Exercise] = [
        Exercise(
            title: "Arthur le Prouteur Magique",
            content: """
            Il etait une fois, dans un petit village au bord de la foret enchantee, un garcon pas comme les autres. Il s'appelait Arthur, et tout le monde le connaissait sous le nom d'Arthur le Prouteur Magique. Pourquoi ce surnom etonnant ? Parce qu'Arthur avait un pouvoir extraordinaire : chacun de ses prouts avait un effet magique different !

            Tout avait commence un matin d'automne, quand Arthur avait mange une soupe de haricots preparee par sa grand-mere Odette. Apres le repas, il avait senti un gargouillement bizarre dans son ventre. Et puis, PROUUUT ! Un enorme prout violet etait sorti, et soudain, toutes les feuilles mortes du jardin s'etaient envolees pour former un magnifique dragon de feuillage qui avait survole le village pendant une heure entiere.

            Depuis ce jour, Arthur avait decouvert que ses prouts avaient chacun un pouvoir unique. Les prouts graves et profonds faisaient pousser des fleurs geantes. Les prouts aigus et sifflants creaient des bulles de savon multicolores. Les prouts discrets et timides rendaient les objets invisibles pendant quelques minutes. Et les prouts tonitruants, ceux qui faisaient trembler les murs, pouvaient faire voler les gens a trois metres du sol !

            Bien sur, au debut, les habitants du village etaient un peu genes. Madame Dupont, la boulangere, avait failli s'evanouir la premiere fois qu'un prout d'Arthur avait transforme toutes ses baguettes en serpentins de fete. Mais petit a petit, tout le monde s'etait habitue. On venait meme de loin pour voir les spectacles d'Arthur.

            Chaque samedi, Arthur donnait un concert de prouts sur la place du village. Les enfants adoraient ca, les parents riaient aux eclats, et meme le maire avait declare : "Arthur est notre tresor national !" Arthur, lui, etait juste content de rendre les gens heureux avec son don un peu particulier. Apres tout, la magie existe sous toutes les formes !
            """,
            type: .lecture
        ),
        Exercise(
            title: "Trottinette Freestyle vs BMX Freestyle",
            content: """
            Tu as surement deja vu des riders faire des figures impressionnantes au skatepark, soit sur une trottinette, soit sur un BMX. Mais quelles sont les differences entre ces deux sports freestyle ? Decouvrons-les ensemble !

            D'abord, parlons du materiel. Une trottinette freestyle est composee d'un deck (la planche ou tu poses les pieds), d'un guidon, de deux roues et d'une fourche. Elle pese generalement entre 3 et 4 kilos. Le BMX, lui, est un velo avec des roues de 20 pouces, un cadre renforce, un guidon qui peut tourner a 360 degres et des pegs (petits tubes sur les axes des roues). Il pese entre 9 et 12 kilos, soit presque trois fois plus qu'une trottinette !

            Ensuite, la prise en main est differente. La trottinette freestyle est souvent consideree comme plus facile pour debuter. Tu restes debout, tes pieds sont proches du sol, et tu peux poser le pied par terre rapidement si tu perds l'equilibre. Avec le BMX, il faut d'abord savoir bien pedaler et garder l'equilibre sur le velo avant de tenter les premieres figures.

            Les figures, justement, sont assez differentes. En trottinette, les tricks les plus populaires sont le tailwhip (la trottinette tourne sous tes pieds), le barspin (le guidon fait un tour complet) et le backflip (un salto arriere avec la trottinette). En BMX, on retrouve aussi le barspin et le backflip, mais il y a des figures specifiques comme le manual (rouler sur la roue arriere), le bunny hop (sauter sans rampe) et les grinds sur les pegs.

            Cote competitions, les deux sports sont reconnus. La trottinette freestyle a ses championnats du monde depuis plusieurs annees, et le BMX freestyle est meme aux Jeux Olympiques depuis Tokyo 2021 ! Les deux disciplines attirent des millions de fans a travers le monde.

            Alors, trottinette ou BMX ? Les deux sont genials, il suffit de choisir celui qui te fait le plus vibrer !
            """,
            type: .lecture
        )
    ]

    init(settings: ExerciseSettings) {
        self.settings = settings
        self.exerciseQueue = Self.predefinedArticles
    }

    func startTimer() {
        stopTimer()
        let minutes = settings.intervalMinutes
        timerTask = Task { @MainActor [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: UInt64(minutes) * 60 * 1_000_000_000)
                if !Task.isCancelled {
                    self?.triggerExercise()
                }
            }
        }
    }

    func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }

    func restartTimer() {
        startTimer()
    }

    func triggerExercise() {
        guard !exerciseQueue.isEmpty else { return }
        currentExercise = exerciseQueue[currentExerciseIndex]
        showExercise = true
    }

    func completeCurrentExercise() {
        showExercise = false
        currentExercise = nil
        currentExerciseIndex += 1
        if currentExerciseIndex >= exerciseQueue.count {
            currentExerciseIndex = 0
        }
        restartTimer()
    }
}
