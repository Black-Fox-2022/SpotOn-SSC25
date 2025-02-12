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

    @State var selectedPoint: (row: Int, col: Int)? = nil

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
                .background(orangeTint)
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
                            mapView(selectedPoint: $selectedPoint)
                                .frame(width: 400, height: 350)

                        }
                    }
                    .padding()
                    .frame(width: 575)
                    .background(.primary.opacity(0.05))
                    .clipShape(.rect(cornerRadius: 15))

                    stationView(selectedPoint: $selectedPoint)


                }
                .padding(.trailing, 35)
            }
        }
        .redacted(reason: .placeholder)
    }
}

// Fire Central     : 17
// Fire Secondary   : 17,24
// EMS              : 16,6

struct stationView: View {
    @Binding var selectedPoint: (row: Int, col: Int)?

    @State var testAnimation = false

    var body: some View {
        VStack {
            if let selectedPoint = selectedPoint {
                if selectedPoint.row == 4 && selectedPoint.col == 17 {
                    station_firecentral()
                } else if selectedPoint.row == 1 && selectedPoint.col == 0 {

                }
                else if selectedPoint.row == 1 && selectedPoint.col == 0 {

                }

            }else {
                Spacer()
                Text("Select a station on the map to see send out units")
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 300)


                Spacer()
            }
        }
        .padding()
        .frame(width: 575)
        .background(.primary.opacity(0.05))
        .clipShape(.rect(cornerRadius: 15))
    }
}

struct station_firecentral: View {
    @State var FS_Main_FE_I_Status: engineStatus = .inStation
    @State var FS_Main_FE_II_Status: engineStatus = .inStation
    @State var FS_Main_RE_I_Status: engineStatus = .inStation
    @State var FS_Main_LE_I_Status: engineStatus = .inStation

    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text("Central Fire Station")
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                Spacer()
                Button(action: {

                }, label: {
                    Text("Call All Units")
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                })
                .background(orangeTint)
                .clipShape(.rect(cornerRadius: 10))
            }

            ScrollView(.horizontal) {
                HStack {
                    EngineRow(
                        title: "Fire Engine I",
                        type: .fireEngine,
                        status: FS_Main_FE_I_Status,
                        action: {
                            FS_Main_FE_I_Status = .responding
                        }
                    )

                    EngineRow(
                        title: "Fire Engine II",
                        type: .fireEngine,
                        status: FS_Main_FE_II_Status,
                        action: {
                            FS_Main_FE_II_Status = .responding
                        }
                    )
                    EngineRow(
                        title: "Command Truck I",
                        type: .commandTruck,
                        status: FS_Main_RE_I_Status,
                        action: {
                            FS_Main_RE_I_Status = .responding
                        }
                    )

                    EngineRow(
                        title: "Ladder Truck I",
                        type: .ladderTruck,
                        status: FS_Main_LE_I_Status,
                        action: {
                            FS_Main_LE_I_Status = .responding
                        }
                    )
                }
            }
            .foregroundStyle(.secondary)
            .padding(.leading, 10)
            .scrollIndicators(.hidden)
            Spacer()
        }
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
                                title: "Command Truck I",
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

enum engineType {
    case fireEngine
    case ladderTruck
    case commandTruck
    case ambulance

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
            case .ladderTruck:
                return "Polling_LF8"
            case .commandTruck:
                return "Polling_MZF"
            case .ambulance:
                return "Assists in medical emergencies"
        }
    }

    private var engineTypeDescription: String {
        switch type {
            case .fireEngine:
                return "Very effective combating fires"
            case .ladderTruck:
                return "Useful in reaching high places"
            case .commandTruck:
                return "Provides support to other units"
            case .ambulance:
                return "Assists in medical emergencies"
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
        /*HStack(spacing: 0) {
            Button(action: action) {
                Text(buttonTitle)
                    .foregroundStyle(buttonForegroundColor)
                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                    .frame(width: 70, alignment: .leading)
            }
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .monospaced))
                .lineLimit(1)
        }*/
        ZStack (alignment: .topTrailing){
            VStack (alignment: .leading, spacing: 0){
                Image(image)
                    .resizable()
                    //.scaledToFit()
                    //.clipped()
                    .frame(width: 200, height: 140)
                VStack (alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                    Text(engineTypeDescription)
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .lineLimit(2, reservesSpace: true)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
            }

            Button(action: {
                status = .responding
            }, label: {
                Image(systemName: "bell")
                    .font(.system(size: 18, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.white)
                    .padding(8)
            })
            .symbolEffect(.wiggle, value: status)
            .background(orangeTint)
            .clipShape(Circle())
            .padding(10)
        }
        .frame(width: 200)
        .background(.primary.opacity(0.05))
        .clipShape(.rect(cornerRadius: 15))
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
