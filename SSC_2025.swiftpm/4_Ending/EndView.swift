//
//  EndView.swift
//  SSC_2025
//
//  Created by Lukas on 16.02.25.
//

import SwiftUI
import AVKit

struct EndView: View {
    @State private var fadeIn = false
    @State private var showSummaries = false

    @State private var showClip1 = false
    @State private var showClip2 = false
    @State private var showClip3 = false

    @State private var isPlayingClip1 = false
    @State private var isPlayingClip2 = false
    @State private var isPlayingClip3 = false

    let link = FirefighterLink(
            country: "Germany",
            title: "#team112",
            subtitle: "Use your strenghts. Change your world!",
            url: "https://team112.bayern/",
            imageName: "Preview_GER_VF",
            countryEmoji: "🇩🇪")


    var body: some View {
        ZStack (alignment: .bottomTrailing) {
            VStack {
                Spacer()

                HStack {
                    Spacer()
                    TypeWriterText(.constant("Firefighters are not just heroes.\nThey are people like you!"))
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.primary)
                    Spacer()
                }

                Spacer()

                VStack(spacing: 5) {
                    Text("Thank you for playing!")
                        .font(.system(size: 20, weight: .semibold, design: .monospaced))
                        .foregroundColor(.primary.opacity(0.8))

                    HStack(spacing: 20) {
                        Text("Created by Lukas")
                        Text("🐦 Twitter")
                    }
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundColor(.primary.opacity(0.6))
                    .padding(.top, 5)
                }
                .animation(.easeOut(duration: 1.2).delay(1.5), value: fadeIn)
                .padding(.bottom, 20)
            }

            FirefighterLinkCard(link: link)
                .padding()
                .animation(.easeOut(duration: 1.2).delay(1.5), value: fadeIn)
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            fadeIn = true
        }
    }

    private func missionSummaryBox(title: String, result: String, lesson: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 22, weight: .bold, design: .monospaced))
                .foregroundColor(.red)

            Text(result)
                .font(.system(size: 18, weight: .medium, design: .monospaced))
                .foregroundColor(.primary)

            Text(lesson)
                .font(.system(size: 16, weight: .regular, design: .monospaced))
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .frame(maxWidth: 500)
        .background(.primary.opacity(0.05))
        .clipShape(.rect(cornerRadius: 20))
        .shadow(radius: 5)
        .padding(.horizontal, 20)
    }
}

struct FirefighterLink: Identifiable {
    let id = UUID()
    let country: String
    let title: String
    let subtitle: String
    let url: String
    let imageName: String
    let countryEmoji: String
}

// 🎨 Firefighter Card View (Fully Clickable)
struct FirefighterLinkCard: View {
    let link: FirefighterLink

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                Image(link.imageName)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 250, height: 150)

                Image(systemName: "link")
                    .imageScale(.medium)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding()
            }
            .frame(width: 250, height: 150)

            VStack(alignment: .leading) {
                Text(link.title)
                    .font(.system(size: 18, weight: .semibold, design: .monospaced))
                    .foregroundColor(orangeTint)

                Text(link.subtitle)
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .frame(width: 250, height: 90, alignment: .leading)

        }
        .background(.primary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onTapGesture {
            mediumFeedback()
            if let url = URL(string: link.url) {
                UIApplication.shared.open(url)
            }
        }
    }
}

class VideoPlayerManager: ObservableObject {
    let player: AVPlayer

    init() {
        if let videoPath = Bundle.main.path(forResource: "VideoClip1", ofType: "MOV") {
            let videoURL = URL(fileURLWithPath: videoPath)
            self.player = AVPlayer(url: videoURL)

            // 🔄 Looping Playback
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: self.player.currentItem,
                queue: .main
            ) { [weak self] _ in
                self?.player.seek(to: .zero)
                self?.player.play()
            }

            self.player.isMuted = true // 🔇 No Sound
        } else {
            self.player = AVPlayer()
        }
    }

    // 🔄 Start or Stop Playback
    func setPlayback(isPlaying: Bool) {
        if isPlaying {
            player.play()
        } else {
            player.pause()
        }
    }
}

// 🎥 Custom Video Player to Hide Controls
struct AVPlayerControllerRepresented: UIViewControllerRepresentable {
    var player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false // ❌ Hides controls
        controller.videoGravity = .resizeAspectFill // 🔥 Scales to fill
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

struct VideoView: View {
    @StateObject private var videoManager = VideoPlayerManager()
    @Binding var isPlaying: Bool

    var body: some View {
        AVPlayerControllerRepresented(player: videoManager.player)
            .frame(width: 250, height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .onAppear {
                videoManager.setPlayback(isPlaying: isPlaying)
            }
            .onChange(of: isPlaying) {
                videoManager.setPlayback(isPlaying: isPlaying)
            }
    }
}

