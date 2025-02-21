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
}

class SoundManager {
    static let shared = SoundManager()

    private var audioPlayer: AVAudioPlayer?
    private var countdownPlayer: AVAudioPlayer?

    private init() {}

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
                    self.audioPlayer?.volume = 0.3
                case .buttonSecondary:
                    self.audioPlayer?.volume = 0.4
                case .buttonAlert:
                    self.audioPlayer?.volume = 0.1
                case .countDown:
                    self.countdownPlayer?.volume = 0.05
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
