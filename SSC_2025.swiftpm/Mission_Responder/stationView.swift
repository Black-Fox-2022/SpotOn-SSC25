//
//  stationView.swift
//  SSC_2025
//
//  Created by Lukas on 15.02.25.
//

import SwiftUI

// Fire Central     : 4, 17
// Fire Secondary   : 17,22
// EMS              : 16,6

struct stationView: View {
    @Binding var selectedPoint: (row: Int, col: Int)?

    @State var testAnimation = false

    var body: some View {
        VStack {
            if let selectedPoint = selectedPoint {
                if selectedPoint.row == 4 && selectedPoint.col == 17 {
                    station_firecentral()
                } else if selectedPoint.row == 17 && selectedPoint.col == 22 {
                    station_firesouth()
                }
                else if selectedPoint.row == 16 && selectedPoint.col == 6 {
                    station_EMS_central()
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
                        type: .secondfireEngine,
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

struct station_firesouth: View {
    @State var FS_West_FE_I_Status: engineStatus = .inStation
    @State var FS_West_FE_II_Status: engineStatus = .inStation
    @State var FS_West_LE_I_Status: engineStatus = .inStation

    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text("Southern Fire Station")
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
                        status: FS_West_FE_I_Status,
                        action: {
                            FS_West_FE_I_Status = .responding
                        }
                    )

                    EngineRow(
                        title: "Fire Engine II",
                        type: .secondfireEngine,
                        status: FS_West_FE_II_Status,
                        action: {
                            FS_West_FE_II_Status = .responding
                        }
                    )

                    EngineRow(
                        title: "Ladder Truck I",
                        type: .ladderTruck,
                        status: FS_West_LE_I_Status,
                        action: {
                            FS_West_LE_I_Status = .responding
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


struct station_EMS_central: View {
    @State var FS_Main_AB_I_Status: engineStatus = .inStation
    @State var FS_Main_AB_II_Status: engineStatus = .inStation
    @State var FS_Main_XXLAB_I_Status: engineStatus = .inStation

    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text("EMS Station")
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
                        title: "Ambulance I",
                        type: .ambulance,
                        status: FS_Main_AB_I_Status,
                        action: {
                            FS_Main_AB_I_Status = .responding
                        }
                    )

                    EngineRow(
                        title: "Ambulance II",
                        type: .ambulance,
                        status: FS_Main_AB_II_Status,
                        action: {
                            FS_Main_AB_II_Status = .responding
                        }
                    )

                    EngineRow(
                        title: "EMS Truck",
                        type: .bigambulance,
                        status: FS_Main_XXLAB_I_Status,
                        action: {
                            FS_Main_XXLAB_I_Status = .responding
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
