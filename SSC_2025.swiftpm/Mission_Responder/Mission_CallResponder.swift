//
//  SwiftUIView.swift
//  SSC_2025
//
//  Created by Lukas on 08.02.25.
//

import SwiftUI
import MapKit

struct Mission_CallResponder: View {
    @State private var isRunning: Bool = false


    var body: some View {
        VStack (spacing: 12){
            HStack {
                TimerText(isRunning: $isRunning)

                Spacer()

                HStack (spacing: 0) {
                    Text("Dispatcher ")
                        .foregroundStyle(.primary.opacity(0.8))
                    Text("Mission II")
                        .foregroundStyle(Color(hex: 0xf96407))
                }
                .font(.system(size: 18, weight: .bold, design: .monospaced))

                Spacer()

                Button(action: {
                    withAnimation(.spring) {
                        isRunning.toggle()
                    }
                }, label: {
                    Text(isRunning ? "Finish Mission" : "Begin Call")
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                })
                .background(Color(hex: 0xf96407))
                .clipShape(.rect(cornerRadius: 10))
            }
            .padding(10)
            .background(.primary.opacity(0.05))
            .clipShape(.rect(cornerRadius: 15))
            .padding(.horizontal, 35)

            HStack (spacing: 12){

                conversationView()

                VStack (spacing: 12){

                    //ressourcesView()

                    VStack {
                        HStack {
                            mapView()
                                .frame(width: 400, height: 350)

                        }
                    }
                    .padding()
                    .frame(width: 575)
                    .background(.primary.opacity(0.05))
                    .clipShape(.rect(cornerRadius: 15))

                    VStack {
                        Spacer()
                        Text("Select a station on the map to see send out units")
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .frame(width: 300)
                        Spacer()
                    }
                    .padding()
                    .frame(width: 575)
                    .background(.primary.opacity(0.05))
                    .clipShape(.rect(cornerRadius: 15))


                }
                .padding(.trailing, 35)
            }
        }
        //.redacted(reason: .placeholder)
    }
}

struct TimerText: View {
    @Binding var isRunning: Bool
    @State private var elapsed: TimeInterval = 0
    @State private var timer: Timer? = nil

    var body: some View {
        Text(formattedTime)
            .font(.system(size: 20, weight: .semibold, design: .monospaced))
            .padding(.horizontal)

            .onChange(of: isRunning) {
                if !isRunning {
                    timer?.invalidate()
                    timer = nil
                    //elapsed = 0
                    isRunning = false
                } else {
                    isRunning = true
                    timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                        elapsed += 0.01
                    }
                }
            }
    }

    private var formattedTime: String {
        let minutes = Int(elapsed) / 60
        let seconds = Int(elapsed) % 60
        let centiseconds = Int((elapsed - Double(Int(elapsed))) * 100)
        return String(format: "%02d:%02d:%02d", minutes, seconds, centiseconds)
    }
}

enum engineStatus {
    case responding
    case inStation
}

struct ressourcesView: View {
    @State var FS_Main_FE_I_Status: engineStatus = .inStation
    @State var FS_Main_FE_II_Status: engineStatus = .inStation
    @State var FS_Main_RE_I_Status: engineStatus = .inStation
    @State var FS_Main_LE_I_Status: engineStatus = .inStation

    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            Text("Available Units")
                .font(.system(size: 22, weight: .bold, design: .monospaced))
                .padding(.bottom)
            HStack {
                VStack(alignment: .leading, spacing: 20){

                    VStack(alignment: .leading, spacing: 5){
                        Text("Fire Station Central" )
                            .font(.system(size: 18, weight: .medium, design: .monospaced))

                        VStack (alignment: .leading){

                            EngineRow(
                                title: "Fire Engine I",
                                status: FS_Main_FE_I_Status,
                                action: {
                                    FS_Main_FE_I_Status = .responding
                                }
                            )

                            EngineRow(
                                title: "Fire Engine II",
                                status: FS_Main_FE_II_Status,
                                action: {
                                    FS_Main_FE_II_Status = .responding
                                }
                            )

                            EngineRow(
                                title: "Rescue Truck I",
                                status: FS_Main_RE_I_Status,
                                action: {
                                    FS_Main_RE_I_Status = .responding
                                }
                            )

                            EngineRow(
                                title: "Ladder Truck I",
                                status: FS_Main_LE_I_Status,
                                action: {
                                    FS_Main_LE_I_Status = .responding
                                }
                            )
                        }
                        .foregroundStyle(.secondary)
                        .padding(.leading, 10)
                    }
                    .frame(height: 100, alignment: .top)

                    VStack(alignment: .leading, spacing: 5){
                        Text("Fire Station South")
                            .font(.system(size: 18, weight: .medium, design: .monospaced))

                        VStack (alignment: .leading){
                            EngineRow(
                                title: "Fire Engine I",
                                status: FS_Main_FE_I_Status,
                                action: {
                                    FS_Main_FE_I_Status = .responding
                                }
                            )

                            EngineRow(
                                title: "Fire Engine II",
                                status: FS_Main_FE_II_Status,
                                action: {
                                    FS_Main_FE_II_Status = .responding
                                }
                            )
                        }
                        .foregroundStyle(.secondary)
                        .padding(.leading, 10)
                    }
                }

                Spacer()

                VStack(alignment: .leading, spacing: 20){

                    VStack(alignment: .leading, spacing: 5){
                        Text("Fire Station North")
                            .font(.system(size: 18, weight: .medium, design: .monospaced))

                        VStack (alignment: .leading){
                            EngineRow(
                                title: "Fire Engine I",
                                status: FS_Main_FE_I_Status,
                                action: {
                                    FS_Main_FE_I_Status = .responding
                                }
                            )

                            EngineRow(
                                title: "Command Vehicle I",
                                status: FS_Main_RE_I_Status,
                                action: {
                                    FS_Main_RE_I_Status = .responding
                                }
                            )

                            EngineRow(
                                title: "Rescue Truck I",
                                status: FS_Main_RE_I_Status,
                                action: {
                                    FS_Main_RE_I_Status = .responding
                                }
                            )
                        }
                        .foregroundStyle(.secondary)
                        .padding(.leading, 10)
                    }
                    .frame(height: 100, alignment: .top)

                    VStack(alignment: .leading, spacing: 5){
                        Text("EMS Station")
                            .font(.system(size: 18, weight: .medium, design: .monospaced))

                        VStack (alignment: .leading){
                            EngineRow(
                                title: "Ambulance I",
                                status: FS_Main_FE_I_Status,
                                action: {
                                    FS_Main_FE_I_Status = .responding
                                }
                            )

                            EngineRow(
                                title: "Ambulance II",
                                status: FS_Main_RE_I_Status,
                                action: {
                                    FS_Main_RE_I_Status = .responding
                                }
                            )
                        }
                        .foregroundStyle(.secondary)
                        .padding(.leading, 10)
                    }
                }
                Spacer()
            }
            .padding(.bottom, 10)
        }
        .padding()
        .frame(width: 600)
        .background(Color.primary.opacity(0.05))
        .clipShape(.rect(cornerRadius: 15))
    }
}

import SwiftUI

struct EngineRow: View {
    let title: String
    var status: engineStatus = .inStation
    let action: () -> Void

    private var buttonTitle: String {
        switch status {
        case .inStation:
            return "Call"
        case .responding:
            return "Resp."
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
        HStack(spacing: 0) {
            Button(action: action) {
                Text(buttonTitle)
                    .foregroundStyle(buttonForegroundColor)
                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                    .frame(width: 70, alignment: .leading)
            }
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .monospaced))
                .lineLimit(1)
        }
    }
}



struct answerOption: View {
    var text: String

    var body: some View {
            Text(text)
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .frame(height: 60)
                    .frame(maxWidth: 180)
                    .background(Color(hex: 0xf96407))
                    .clipShape(.rect(cornerRadius: 10))
    }
}


struct textBubble: View {
    @Environment(\.colorScheme) var colorScheme

    var text: String
    var isIncoming: Bool = false

    var body: some View {
        HStack{
            if !isIncoming {
                Spacer(minLength: 100)
            }

            HStack {
                Text(text)
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .foregroundStyle(isIncoming ? colorScheme == .light ? .black : .white : Color(hex: 0xf96407))
                if isIncoming {
                    //Spacer(minLength: 1)
                }
            }
            .padding()
            .background(isIncoming ? colorScheme == .light ? .black.opacity(0.1) : .white.opacity(0.1) : Color(hex: 0xf96407).opacity(0.25))
            .clipShape(.rect(cornerRadius: 10))

            if isIncoming {
                Spacer(minLength: 125)
            }
        }
    }
}

#Preview {
    Mission_CallResponder()
}
