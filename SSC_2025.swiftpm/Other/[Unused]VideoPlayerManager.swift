//
//  VideoPlayerManager.swift
//  FireKIt
//
//  Created by Lukas on 16.02.25.
//
import SwiftUI
import AVFoundation
import AVKit



class VideoPlayerManager: ObservableObject {
    let player: AVPlayer

    init() {
        if let videoPath = Bundle.main.path(forResource: "VideoClip1", ofType: "MOV") {
            let videoURL = URL(fileURLWithPath: videoPath)
            self.player = AVPlayer(url: videoURL)

            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: self.player.currentItem,
                queue: .main
            ) { [weak self] _ in
                self?.player.seek(to: .zero)
                self?.player.play()
            }

            self.player.isMuted = true
        } else {
            self.player = AVPlayer()
        }
    }

    func setPlayback(isPlaying: Bool) {
        if isPlaying {
            player.play()
        } else {
            player.pause()
        }
    }
}

struct AVPlayerControllerRepresented: UIViewControllerRepresentable {
    var player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
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
