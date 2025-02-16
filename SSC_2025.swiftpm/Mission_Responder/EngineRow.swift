//
//  engineType.swift
//  SSC_2025
//
//  Created by Lukas on 16.02.25.
//
import SwiftUI
import AVFoundation
import TipKit

enum engineType {
    case fireEngine
    case secondfireEngine
    case ladderTruck
    case commandTruck
    case ambulance
    case bigambulance
}

struct EngineRow: View {
    let title: String
    var type: engineType = .fireEngine
    @State var status: engineStatus = .inStation
    let action: () -> Void

    private var buttonTitle: String {
        switch status {
        case .inStation:
            return "Call"
        case .responding:
            return "Resp."
        }
    }

    private var image: String {
        switch type {
        case .fireEngine:
            return "Polling_LF20"
        case .secondfireEngine:
            return "Polling_LF8"
        case .ladderTruck:
            return "Peißenberg_DLK"
        case .commandTruck:
            return "Polling_MZF"
        case .ambulance:
            return "Sons_RTW"
        case .bigambulance:
            return "Sons_S-RTW"
        }
    }

    private var engineTypeDescription: String {
        switch type {
        case .fireEngine:
            return "Very effective combating fires"
        case .secondfireEngine:
            return "Very effective combating fires"
        case .ladderTruck:
            return "Useful in reaching high places"
        case .commandTruck:
            return "Helps to coordinate other units"
        case .ambulance:
            return "Assists in medical emergencies"
        case .bigambulance:
            return "Can transport multiple patients"
        }
    }

    private var buttonForegroundColor: Color {
        switch status {
        case .inStation:
            return Color(hex: 0xf96407)
        case .responding:
            return .blue
        }
    }

    var body: some View {
        Button(action: {
            withAnimation(.spring) {
                status = .responding
                action()
            }
        }, label: {
            ZStack (alignment: .topTrailing){
                VStack (alignment: .leading, spacing: 0){
                    Image(image)
                        .resizable()
                        .frame(width: 200, height: 125)
                    VStack (alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.system(size: 16, weight: .semibold, design: .monospaced))
                            .foregroundStyle(.primary)
                        Text(engineTypeDescription)
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2, reservesSpace: true)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                }

                HStack {
                    Text(status == .inStation ? "Call" : "Responding")
                    Image(systemName: status == .inStation ? "phone.fill" : "light.beacon.max.fill")
                        .imageScale(.small)
                        .offset(y: -1)
                        .symbolEffect(.pulse, options: .repeating, value: status == .responding)
                }
                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                    .background(orangeTint)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(10)
            }
            .frame(width: 200)
        })
        .background(.primary.opacity(0.05))
        .clipShape(.rect(cornerRadius: 12))
    }
}

/* guard let url = Bundle.main.url(forResource: "alarm sound", withExtension: "mp3") else {
     print("Audio file not found")
     return
 }

 do {
     let audioPlayer = try AVAudioPlayer(contentsOf: url)
     audioPlayer.play()
 } catch {
     print(error.localizedDescription)
 }*/
