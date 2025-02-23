//
//  AudioFeedback.swift
//  SSC_2025
//
//  Created by Lukas on 16.02.25.
//

import AVFoundation

enum SoundType {
    case buttonPrimary
    case buttonSecondary
    case buttonAlert
    case countDown
    case typingONE
}

class SoundManager {
    static let shared = SoundManager()

    private var audioPlayer: AVAudioPlayer?
    private var countdownPlayer: AVAudioPlayer?

    private init() {}

    func stopAnySound() {
        self.audioPlayer?.stop()
        self.countdownPlayer?.stop()

        self.audioPlayer = nil
        self.countdownPlayer = nil
    }

    func playSound(type: SoundType) {
        var fileName: String?

        switch type {
        case .buttonPrimary:
            fileName = "Button2-Sound"
        case .buttonSecondary:
            fileName = "Button1-Sound"
        case .buttonAlert:
            fileName = "Alert1-Sound"
        case .countDown:
            fileName = "Countdown10Sec"
        case .typingONE:
            fileName = "TypingSound-1"
        }

        guard let fileName = fileName, let url = Bundle.main.url(forResource: fileName, withExtension: type == .countDown ? "mp3" : "m4a") else {
            print("🚨 Audio file not found")
            return
        }

            do {
                if type == .countDown {
                    self.countdownPlayer = try AVAudioPlayer(contentsOf: url)
                    self.countdownPlayer?.prepareToPlay()
                }else {
                    self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                    self.audioPlayer?.prepareToPlay()
                }

                switch type {
                case .buttonPrimary:
                    self.audioPlayer?.volume = 0.5
                case .buttonSecondary:
                    self.audioPlayer?.volume = 0.9
                case .buttonAlert:
                    self.audioPlayer?.volume = 0.1
                case .countDown:
                    self.countdownPlayer?.volume = 0.05
                case .typingONE:
                    self.audioPlayer?.volume = 0.05
                    self.audioPlayer?.rate = 1.0
                }

                print("Playing sound: \(fileName)")
                if type == .countDown {
                    self.countdownPlayer?.play()
                }else {
                    self.audioPlayer?.play()
                }
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
    }
}
