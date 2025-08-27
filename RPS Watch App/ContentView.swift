//
//  ContentView.swift
//  RPS Watch App
//
//  Created by Mirvaben Dudhagara on 8/25/25.
//

import SwiftUI
import WatchKit

enum Move: String, CaseIterable, Identifiable {
    case rock = "✊", paper = "✋", scissors = "✌️"
    var id: String { rawValue }
    
    var color: Color {
        switch self {
        case .rock: return .red
        case .paper: return .blue
        case .scissors: return .green
        }
    }
}

enum RoundOutcome: String { 
    case win = "Victory!", lose = "Defeat!", draw = "Tie!" 
}

enum MatchOutcome: String { 
    case you = "Champion!", cpu = "CPU Wins!" 
}

private enum Stage: Equatable {
    case selecting
    case reveal
    case matchOver(MatchOutcome)
}

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var x: Double
    var y: Double
    var rotation: Double
    var scale: Double
    var opacity: Double = 1.0
    var color: Color
    var type: ConfettiType
    
    enum ConfettiType {
        case circle, square, star
    }
}

struct ContentView: View {
    @AppStorage("matchesWon") private var matchesWon = 0
    @AppStorage("matchesLost") private var matchesLost = 0

    @State private var stage: Stage = .selecting
    @State private var player: Move = .rock
    @State private var cpu: Move? = nil

    @State private var round = 1
    @State private var youRounds = 0
    @State private var cpuRounds = 0
    @State private var lastRoundOutcome: RoundOutcome? = nil

    // Enhanced animations
    @State private var animateYouPulse = false
    @State private var animateCPUPulse = false
    @State private var showTrophy = false
    @State private var confetti: [ConfettiPiece] = []
    @State private var showVictoryGlow = false
    @State private var cardScale: CGFloat = 1.0
    @State private var showShockwave = false

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.2), Color.pink.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Main content
            VStack(spacing: 4) {
                // Header
                headerSection
                
                Spacer(minLength: 2)
                
                // Main content
                mainContentSection
                
                Spacer(minLength: 2)
                
                // Footer
                footerSection
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            
            // Confetti overlay
            confettiOverlay
        }
        .animation(.easeOut(duration: 0.3), value: stage)
    }
    
    // MARK: - Background & Effects
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.2), Color.pink.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var confettiOverlay: some View {
        ZStack {
            ForEach(confetti) { piece in
                confettiPiece(piece)
            }
        }
    }
    
    private func confettiPiece(_ piece: ConfettiPiece) -> some View {
        Group {
            switch piece.type {
            case .circle:
                Circle()
                    .fill(piece.color)
                    .frame(width: 4, height: 4)
            case .square:
                Rectangle()
                    .fill(piece.color)
                    .frame(width: 4, height: 4)
            case .star:
                Image(systemName: "star.fill")
                    .foregroundColor(piece.color)
                    .font(.system(size: 6))
            }
        }
        .scaleEffect(piece.scale)
        .rotationEffect(.degrees(piece.rotation))
        .opacity(piece.opacity)
        .position(x: piece.x, y: piece.y)
        .animation(.easeOut(duration: 1.5), value: piece.y)
    }
    
    private var victoryGlowEffect: some View {
        RadialGradient(
            colors: [Color.yellow.opacity(0.6), Color.clear],
            center: .center,
            startRadius: 20,
            endRadius: 80
        )
        .scaleEffect(showVictoryGlow ? 1.5 : 0.5)
        .opacity(showVictoryGlow ? 1 : 0)
        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: showVictoryGlow)
    }
    
    private var shockwaveEffect: some View {
        Circle()
            .stroke(Color.white.opacity(0.8), lineWidth: 2)
            .scaleEffect(showShockwave ? 3 : 0.1)
            .opacity(showShockwave ? 0 : 1)
            .animation(.easeOut(duration: 0.6), value: showShockwave)
    }
    
    // MARK: - Main Sections
    
    private var headerSection: some View {
        VStack(spacing: 3) {
            // Match statistics
            HStack {
                Text("🏆 \(matchesWon)")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.green)
                
                Spacer()
                
                Text("💀 \(matchesLost)")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
            .frame(maxWidth: .infinity)
            
            // Round indicator
            Text("Round \(round)/3")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 3)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                        )
                )
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 4)
    }
    
    private var mainContentSection: some View {
        Group {
            switch stage {
            case .selecting:
                selectingView
            case .reveal:
                revealView
            case .matchOver(let winner):
                matchOverView(winner)
            }
        }
    }
    
    private var footerSection: some View {
        HStack(spacing: 8) {
            switch stage {
            case .selecting:
                Button("Reset") {
                    resetMatch(hard: true)
                    haptic(.click)
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .font(.system(size: 11))

            case .reveal:
                if isMatchDecided {
                    Button("Result") { 
                        finishMatch()
                        haptic(.success)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    .font(.system(size: 11))
                } else {
                    Button("Next") { 
                        goToNextRound()
                        haptic(.click)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .font(.system(size: 11))
                }

            case .matchOver:
                Button("Play Again") {
                    resetMatch(hard: false)
                    haptic(.click)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .font(.system(size: 11))
            }
        }
    }
    
    // MARK: - Stage Views
    
    private var selectingView: some View {
        VStack(spacing: 6) {
            Text("Choose Your Weapon!")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 8) {
                ForEach(Move.allCases) { move in
                    choiceButton(move)
                }
            }
        }
        .scaleEffect(cardScale)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: cardScale)
    }
    
    private var revealView: some View {
        VStack(spacing: 4) {
            HStack(spacing: 8) {
                battleCard(emoji: player.rawValue, title: "You", isWinner: lastRoundOutcome == .win, pulse: $animateYouPulse, color: player.color)
                battleCard(emoji: cpu?.rawValue ?? "🤖", title: "CPU", isWinner: lastRoundOutcome == .lose, pulse: $animateCPUPulse, color: cpu?.color ?? .gray)
            }
            .transition(.asymmetric(
                insertion: .scale.combined(with: .opacity),
                removal: .scale.combined(with: .opacity)
            ))

            if let lastRoundOutcome {
                outcomeDisplay(lastRoundOutcome)
            }

            HStack {
                Text("You \(youRounds)")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.green)
                
                Text("|")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                
                Text("\(cpuRounds) CPU")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(.ultraThinMaterial)
            .cornerRadius(6)
        }
    }
    
    private func matchOverView(_ winner: MatchOutcome) -> some View {
        VStack(spacing: 6) {
            if showTrophy {
                Text("🏆")
                    .font(.system(size: 36))
                    .scaleEffect(showTrophy ? 1.2 : 0.8)
                    .animation(.spring(response: 0.4, dampingFraction: 0.4, blendDuration: 0.2).repeatForever(autoreverses: true), value: showTrophy)
                    .transition(.scale.combined(with: .opacity))
            }
            
            Text(winner.rawValue)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(winner == .you ? .green : .red)
                .transition(.opacity.combined(with: .scale))
            
            Text("Final: \(youRounds) - \(cpuRounds)")
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
        .onAppear {
            showTrophy = true
            if case .you = winner { 
                haptic(.success)
                triggerVictoryEffects()
            } else { 
                haptic(.failure) 
            }
        }
        .onDisappear { showTrophy = false }
    }
    
    // MARK: - Components
    
    private func choiceButton(_ move: Move) -> some View {
        Button {
            player = move
            haptic(.click)
            cardScale = 0.95
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                cardScale = 1.0
                reveal()
            }
        } label: {
            VStack(spacing: 1) {
                ZStack {
                    Circle()
                        .fill(move.color.opacity(0.2))
                        .overlay(
                            Circle()
                                .stroke(move.color, lineWidth: 2)
                        )
                        .frame(width: 40, height: 40)
                    
                    Text(move.rawValue)
                        .font(.system(size: 16))
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    private func battleCard(emoji: String, title: String, isWinner: Bool, pulse: Binding<Bool>, color: Color) -> some View {
        VStack(spacing: 1) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isWinner ? color : Color.clear, lineWidth: 2)
                    )
                    .frame(width: 50, height: 50)
                    .scaleEffect(pulse.wrappedValue ? 1.1 : 1.0)
                    .animation(isWinner ? .spring(response: 0.25, dampingFraction: 0.35, blendDuration: 0.1) : .default, value: pulse.wrappedValue)
                
                Text(emoji)
                    .font(.system(size: 18))
            }
            
            Text(title)
                .font(.system(size: 8, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
    
    private func outcomeDisplay(_ outcome: RoundOutcome) -> some View {
        Text(outcome.rawValue)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(outcomeColor(outcome))
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(outcomeColor(outcome).opacity(0.5), lineWidth: 1)
                    )
            )
            .transition(.asymmetric(
                insertion: .scale.combined(with: .opacity),
                removal: .scale.combined(with: .opacity)
            ))
    }
    
    // MARK: - Logic
    
    private func outcomeColor(_ outcome: RoundOutcome) -> Color {
        switch outcome {
        case .win: return .green
        case .lose: return .red
        case .draw: return .orange
        }
    }
    
    private func reveal() {
        let cpuPick = Move.allCases.randomElement()!
        cpu = cpuPick

        let result: RoundOutcome
        switch (player, cpuPick) {
        case _ where player == cpuPick:
            result = .draw
            haptic(.notification)
        case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
            result = .win
            youRounds += 1
            animateYouPulse = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { animateYouPulse = false }
            haptic(.success)
        default:
            result = .lose
            cpuRounds += 1
            animateCPUPulse = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { animateCPUPulse = false }
            haptic(.failure)
        }
        lastRoundOutcome = result
        stage = .reveal
    }
    
    private var isMatchDecided: Bool {
        youRounds == 2 || cpuRounds == 2 || (round == 3 && lastRoundOutcome != .draw)
    }
    
    private func goToNextRound() {
        guard lastRoundOutcome != .draw else { stage = .selecting; return }
        if youRounds == 2 || cpuRounds == 2 { finishMatch(); return }
        if round < 3 { round += 1; stage = .selecting } else { finishMatch() }
    }
    
    private func finishMatch() {
        let winner: MatchOutcome = (youRounds > cpuRounds) ? .you : .cpu
        if winner == .you { 
            matchesWon += 1
            triggerVictoryEffects()
        } else { 
            matchesLost += 1
        }
        stage = .matchOver(winner)
    }
    
    private func resetMatch(hard: Bool) {
        round = 1
        youRounds = 0
        cpuRounds = 0
        lastRoundOutcome = nil
        cpu = nil
        player = .rock
        stage = .selecting
        if hard { matchesWon = 0; matchesLost = 0 }
        
        // Clear effects
        confetti.removeAll()
        showVictoryGlow = false
        showShockwave = false
    }
    
    // MARK: - Animation Effects
    
    private func triggerVictoryEffects() {
        // Confetti
        createConfetti()
        
        // Victory glow
        showVictoryGlow = true
        
        // Shockwave
        showShockwave = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            showShockwave = false
        }
    }
    
    private func createConfetti() {
        let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange, .pink]
        let types: [ConfettiPiece.ConfettiType] = [.circle, .square, .star]
        
        // Clear any existing confetti
        confetti.removeAll()
        
        for _ in 0..<15 {
            let piece = ConfettiPiece(
                x: Double.random(in: 30...150),
                y: -30,
                rotation: Double.random(in: 0...360),
                scale: Double.random(in: 0.5...1.2),
                color: colors.randomElement()!,
                type: types.randomElement()!
            )
            confetti.append(piece)
        }
        
        // Animate confetti falling and then exiting
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 1.5)) {
                for i in confetti.indices {
                    confetti[i].y = Double.random(in: 160...200)
                    confetti[i].rotation += Double.random(in: 180...720)
                }
            }
        }
        
        // Fade out and remove confetti
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(.easeInOut(duration: 0.8)) {
                for i in confetti.indices {
                    confetti[i].scale = 0
                    confetti[i].opacity = 0
                }
            }
            
            // Remove from array after fade out
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                confetti.removeAll()
            }
        }
    }
    
    private func haptic(_ type: WKHapticType) {
        WKInterfaceDevice.current().play(type)
    }
}

#Preview { ContentView() }
