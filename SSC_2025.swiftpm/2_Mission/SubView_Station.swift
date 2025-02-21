//
//  stationView.swift
//  SSC_2025
//
//  Created by Lukas on 15.02.25.
//

import SwiftUI
import AVFoundation
import TipKit

// Fire Central     : 4, 17
// Fire Secondary   : 17,22
// EMS              : 16,6

struct stationView: View {
    @Binding var selectedPoint: (row: Int, col: Int)?
    @Binding var countRespondingUnits: [engineType]
    @Binding var respondingFromCentral: Bool

    @State var testAnimation = false

    var body: some View {
        VStack {
            if let selectedPoint = selectedPoint {
                ZStack {
                    station_firecentral(countRespondingUnits: $countRespondingUnits, respondingFromCentral: $respondingFromCentral)
                        .opacity(selectedPoint.row == 4 && selectedPoint.col == 17 ? 1.0 : 0.0)
                    station_firesouth(countRespondingUnits: $countRespondingUnits)
                        .opacity(selectedPoint.row == 17 && selectedPoint.col == 22 ? 1.0 : 0.0)
                    station_EMS_central(countRespondingUnits: $countRespondingUnits)
                        .opacity(selectedPoint.row == 16 && selectedPoint.col == 6 ? 1.0 : 0.0)
                }

            }else {
                VStack {
                    HStack (spacing: 4){
                        Text("Select a station")
                        Circle()
                            .fill(.blue.opacity(0.7))
                            .frame(width: 10, height: 10)
                            .padding(.trailing, 4)
                        Text("on the map")
                    }
                    Text("to send out units")
                }
                .font(.system(size: 16, weight: .medium, design: .monospaced))
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 300)
            }
        }
        .padding()
        .frame(width: 575, height: 275)
        .background(.primary.opacity(0.05))
        .clipShape(.rect(cornerRadius: 15))
    }
}

struct station_firecentral: View {
    @Binding var countRespondingUnits: [engineType]
    @Binding var respondingFromCentral: Bool

    @State var FS_Main_FE_I_Status: engineStatus = .inStation
    @State var FS_Main_FE_II_Status: engineStatus = .inStation
    @State var FS_Main_RE_I_Status: engineStatus = .inStation
    @State var FS_Main_LE_I_Status: engineStatus = .inStation

    var respEngineCount: Int {
        return (
            (FS_Main_FE_I_Status == .responding ? 1 : 0) +
            (FS_Main_FE_II_Status == .responding ? 1 : 0) +
            (FS_Main_RE_I_Status == .responding ? 1 : 0) +
            (FS_Main_LE_I_Status == .responding ? 1 : 0)
        )
    }

    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text("Central Fire Station")
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                Spacer()
                Text("\(respEngineCount)/4 Responding")
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundStyle(redTint)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                    .background(redTint.opacity(0.25))
                    .clipShape(.rect(cornerRadius: 8))
            }

            ScrollView(.horizontal) {
                HStack (spacing: 10){
                    EngineRow(
                        title: "Fire Engine I",
                        type: .fireEngine,
                        status: FS_Main_FE_I_Status,
                        action: {
                            FS_Main_FE_I_Status = .responding
                            countRespondingUnits.append(.fireEngine)
                        }
                    )

                    EngineRow(
                        title: "Fire Engine II",
                        type: .secondfireEngine,
                        status: FS_Main_FE_II_Status,
                        action: {
                            FS_Main_FE_II_Status = .responding
                            countRespondingUnits.append(.fireEngine)
                        }
                    )
                    EngineRow(
                        title: "Command Truck I",
                        type: .commandTruck,
                        status: FS_Main_RE_I_Status,
                        action: {
                            FS_Main_RE_I_Status = .responding
                            countRespondingUnits.append(.commandTruck)
                        }
                    )

                    EngineRow(
                        title: "Ladder Truck I",
                        type: .ladderTruck,
                        status: FS_Main_LE_I_Status,
                        action: {
                            FS_Main_LE_I_Status = .responding
                            countRespondingUnits.append(.ladderTruck)
                        }
                    )
                }
            }
            .foregroundStyle(.secondary)
            .scrollIndicators(.hidden)
        }
        .onChange(of: respEngineCount) {
            respondingFromCentral = respEngineCount > 2
        }
    }
}

struct station_firesouth: View {
    @Binding var countRespondingUnits: [engineType]

    @State var FS_South_FE_I_Status: engineStatus = .inStation
    @State var FS_South_FE_II_Status: engineStatus = .inStation
    @State var FS_South_LE_I_Status: engineStatus = .inStation

    var respEngineCount: Int {
        return (
            (FS_South_FE_I_Status == .responding ? 1 : 0) +
            (FS_South_FE_II_Status == .responding ? 1 : 0) +
            (FS_South_LE_I_Status == .responding ? 1 : 0)
        )
    }

    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text("Southern Fire Station")
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                Spacer()
                Text("\(respEngineCount)/3 Responding")
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundStyle(redTint)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                    .background(redTint.opacity(0.25))
                    .clipShape(.rect(cornerRadius: 8))
            }

            ScrollView(.horizontal) {
                HStack (spacing: 10){
                    EngineRow(
                        title: "Fire Engine I",
                        type: .fireEngine,
                        status: FS_South_FE_I_Status,
                        action: {
                            FS_South_FE_I_Status = .responding
                            countRespondingUnits.append(.fireEngine)
                        }
                    )

                    EngineRow(
                        title: "Fire Engine II",
                        type: .secondfireEngine,
                        status: FS_South_FE_II_Status,
                        action: {
                            FS_South_FE_II_Status = .responding
                            countRespondingUnits.append(.fireEngine)
                        }
                    )

                    EngineRow(
                        title: "Ladder Truck I",
                        type: .ladderTruck,
                        status: FS_South_LE_I_Status,
                        action: {
                            FS_South_LE_I_Status = .responding
                            countRespondingUnits.append(.ladderTruck)
                        }
                    )
                }
            }
            .foregroundStyle(.secondary)
            .scrollIndicators(.hidden)
        }
    }
}


struct station_EMS_central: View {
    @Binding var countRespondingUnits: [engineType]

    @State var FS_Main_AB_I_Status: engineStatus = .inStation
    @State var FS_Main_AB_II_Status: engineStatus = .inStation
    @State var FS_Main_XXLAB_I_Status: engineStatus = .inStation

    var respEngineCount: Int {
        return (
            (FS_Main_AB_I_Status == .responding ? 1 : 0) +
            (FS_Main_AB_II_Status == .responding ? 1 : 0) +
            (FS_Main_XXLAB_I_Status == .responding ? 1 : 0)
        )
    }

    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text("EMS Station")
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                Spacer()
                Text("\(respEngineCount)/3 Responding")
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundStyle(redTint)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                    .background(redTint.opacity(0.25))
                    .clipShape(.rect(cornerRadius: 8))
            }

            ScrollView(.horizontal) {
                HStack (spacing: 10){
                    EngineRow(
                        title: "Ambulance I",
                        type: .ambulance,
                        status: FS_Main_AB_I_Status,
                        action: {
                            FS_Main_AB_I_Status = .responding
                            countRespondingUnits.append(.ambulance)
                        }
                    )

                    EngineRow(
                        title: "Ambulance II",
                        type: .ambulance,
                        status: FS_Main_AB_II_Status,
                        action: {
                            FS_Main_AB_II_Status = .responding
                            countRespondingUnits.append(.ambulance)
                        }
                    )

                    EngineRow(
                        title: "EMS Truck",
                        type: .bigambulance,
                        status: FS_Main_XXLAB_I_Status,
                        action: {
                            FS_Main_XXLAB_I_Status = .responding
                            countRespondingUnits.append(.bigambulance)
                        }
                    )
                }
            }
            .foregroundStyle(.secondary)
            .scrollIndicators(.hidden)
        }
    }
}
