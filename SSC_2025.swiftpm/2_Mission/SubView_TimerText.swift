//
//  TimerText.swift
//  FireKIt
//
//  Created by Lukas on 21.02.25.
//

import SwiftUI

struct TimerText: View {
    @Binding var isRunning: Bool
    @Binding var under30Seconds: Bool

    @State private var remainingTime: TimeInterval = 60.0
    @State private var timer: Timer? = nil
    @State private var flashTimer: Timer? = nil

    @State private var startedRedFlash = false
    @State private var flashRed = false

    var body: some View {
        Text(formattedTime)
            .frame(width: 100, alignment: .leading)
            .font(.system(size: 20, weight: .semibold, design: .monospaced))
            .foregroundColor(remainingTime < 0.02 ? .red : remainingTime < 10 ? (flashRed ? .red : .primary) : .primary)
            .padding(.horizontal)
            .onChange(of: isRunning) {
                if isRunning {
                    startTimer()
                } else {
                    stopTimer()
                }
            }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 0.01

                if remainingTime < 10 && !startedRedFlash {
                    SoundManager.shared.playSound(type: .countDown)
                    startedRedFlash = true
                    startFlashing()
                }
                if remainingTime < 30 {
                    withAnimation(.spring) {
                        under30Seconds = true
                    }
                }
            } else {
                stopTimer()
            }
        }
        RunLoop.current.add(timer!, forMode: .common)
    }

    private func stopTimer() {
        SoundManager.shared.stopAnySound()
        timer?.invalidate()
        timer = nil
        flashTimer?.invalidate()
        flashTimer = nil
        withAnimation {
            isRunning = false
        }
    }

    private func startFlashing() {
        flashTimer?.invalidate()
        flashTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                withAnimation(.spring) {
                    flashRed.toggle()
                }
            }
        }
    }

    private var formattedTime: String {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        let centiseconds = Int((remainingTime - Double(Int(remainingTime))) * 100)
        return String(format: "%02d.%02d.%02d", minutes, seconds, centiseconds)
    }
}
