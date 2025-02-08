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
        HStack (spacing: 20){

            conversationView()

            VStack (spacing: 20){
                HStack {
                    TimerText(isRunning: $isRunning)

                    Spacer()

                    Button(action: {
                        withAnimation(.spring) {
                            isRunning.toggle()
                        }
                    }, label: {
                        Text(isRunning ? "Finish Call" : "Begin Call")
                            .font(.system(size: 16, weight: .semibold, design: .monospaced))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                    })
                    .background(Color(hex: 0xf96407))
                    .clipShape(.rect(cornerRadius: 15))
                }
                .padding(10)
                .background(.primary.opacity(0.05))
                .clipShape(.rect(cornerRadius: 25))

                Map()
                    .frame(width: 550)
                    .clipShape(.rect(cornerRadius: 25))
                ressourcesView()
            }
            .padding(.vertical, 10)
            .padding(.trailing, 35)
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

struct conversationView: View {
    var body: some View {
        VStack (spacing: 10){
            ZStack (alignment: .bottom) {
                VStack (alignment: .leading, spacing: 10){
                    Text("Conversation")
                        .font(.system(size: 22, weight: .bold, design: .monospaced))
                        .padding(.bottom)

                    textBubble(text: "Hello! Please, I need help fast.", isIncoming: true)
                    textBubble(text: "Where are you right now?", isIncoming: false)
                    textBubble(text: "Infront of my house. Hauptstraße 59", isIncoming: true)
                    textBubble(text: "What happened?", isIncoming: false)
                    textBubble(text: "I messed up the pasta! The kitchen is burning!!!", isIncoming: true)

                    Spacer()
                }
                .padding()
                .frame(maxHeight: .infinity)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 25))

                VStack (spacing: 8){
                    ScrollView(.horizontal) {
                        HStack {
                            answerOption(text: "Is anyone still in the building?")
                            Spacer()
                            answerOption(text: "Which pasta did you mess up?")
                            Spacer()
                            answerOption(text: "Can you see flames from the windows?")
                        }
                        .padding(10)
                    }
                    .padding(.horizontal, 1)
                    .scrollIndicators(.hidden)
                    .background(.primary.opacity(0.05))
                    .clipShape(.rect(cornerRadius: 20))
                }
                .padding(10)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.leading, 35)
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
            Text("Available Resources")
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
        .frame(width: 550)
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 25))
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
                    .foregroundStyle(isIncoming ? .black : .white)
                if isIncoming {
                    Spacer(minLength: 1)
                }
            }
            .padding()
            .background(isIncoming ? .black.opacity(0.1) : Color(hex: 0xf96407))
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
