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
            return "LF20-CC-Pixabay"
        case .secondfireEngine:
            return "LF20-CC-Pixabay"
        case .ladderTruck:
            return "DLK-CC-Pixabay"
        case .commandTruck:
            return "ELW-CC-Pixabay"
        case .ambulance:
            return "RTW-CC-Pixabay"
        case .bigambulance:
            return "Int_RTW-CC"
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
                mediumFeedback()
                SoundManager.shared.playSound(type: .buttonAlert)
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
                    .background(redTint)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(10)
            }
            .frame(width: 200)
        })
        .disabled(status == .responding)
        .background(.primary.opacity(0.05))
        .clipShape(.rect(cornerRadius: 12))
    }
}
