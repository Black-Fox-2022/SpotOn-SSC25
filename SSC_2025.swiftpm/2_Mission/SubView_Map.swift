//
//  SwiftUIView.swift
//  SSC_2025
//
//  Created by Lukas on 09.02.25.
//

import SwiftUI

struct mapView: View {

    @Binding var selectedPoint: (row: Int, col: Int)?
    @Binding var knowsLocation: Bool
    @Binding var countRespondingUnits: [engineType]
    @Binding var isRunning: Bool

    // Fire Central     : 4,17
    // Fire Secondary   : 17,24
    // EMS              : 16,6

    let localMatrix: [[Int]] = [
        // Row 0             10                  20
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,1,1,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0],
        [0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,0,0,0,0,0],
        // 5
        [0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0],
        [0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0],
        [0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0],
        [0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,0],
        [0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
        // 10
        [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
        [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0],
        [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
        [0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
        [0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
        // 15
        [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0],
        [1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
        [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,0,0,0,0,0,0],
        [0,0,0,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0],
        [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,1,1,1,0,0,1,1,1,1,1,1,1,0,0,0],
        // 20
        [0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,1,1,1,0,0,0,0,0],
    ]


    let dotSize: CGFloat = 10
    let spacing: CGFloat = 0

    @State private var activePoint: (row: Int, col: Int)? = (row: 9, col: 7)
    @State private var fadingPoint: (row: Int, col: Int)? = nil
    
    @State private var emergencyLocation: String = ""

    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack(spacing: spacing) {
                    ForEach(0..<localMatrix.count, id: \.self) { row in
                        HStack(spacing: spacing) {
                            ForEach(0..<localMatrix[row].count, id: \.self) { col in
                                if localMatrix[row][col] == 1 {
                                    if knowsLocation {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(
                                                    (activePoint?.row == row && activePoint?.col == col) ? Color.red :
                                                        (fadingPoint?.row == row && fadingPoint?.col == col) ? Color.red.opacity(0.6) :
                                                        Color.primary.opacity(0.5)
                                                )
                                                .frame(width: dotSize, height: dotSize)
                                                .animation(.spring(duration: 0.7), value: activePoint != nil)
                                                .animation(.easeOut(duration: 0.5), value: fadingPoint == nil)
                                                .padding(3)

                                            if activePoint?.row == row && activePoint?.col == col {
                                                EmergencyRipple(dotSize: dotSize)
                                            }
                                        }
                                    }
                                } else if localMatrix[row][col] == 2 {
                                    if knowsLocation {
                                        Button(action: {
                                            lightFeedback()
                                            SoundManager.shared.playSound(type: .buttonSecondary)
                                            withAnimation(.spring) {
                                                if let point = selectedPoint {
                                                    if point == (row: row, col: col) {
                                                        selectedPoint = nil
                                                    }else {
                                                        selectedPoint = (row: row, col: col)
                                                    }
                                                } else {
                                                    selectedPoint = (row: row, col: col)
                                                }
                                            }
                                        }, label: {
                                            if let selectedPoint = selectedPoint, selectedPoint.row == row && selectedPoint.col == col {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .foregroundColor(.blue)
                                                        .frame(width: dotSize, height: dotSize)

                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(.clear)
                                                        .stroke(Color.blue, lineWidth: 2)
                                                        .frame(width: dotSize + 4, height: dotSize + 4)
                                                }
                                                .frame(width: dotSize + 6, height: dotSize + 6)
                                            }else {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(.blue.opacity(0.9))
                                                    .frame(width: dotSize, height: dotSize)
                                                    .padding(3)
                                            }
                                        })
                                        .containerShape(Rectangle())
                                        .overlay(
                                            Button(action: {
                                                SoundManager.shared.playSound(type: .buttonSecondary)
                                                withAnimation(.spring) {
                                                    if let point = selectedPoint {
                                                        if point == (row: row, col: col) {
                                                            selectedPoint = nil
                                                            print("point: \(String(describing: selectedPoint))")
                                                        }else {
                                                            selectedPoint = (row: row, col: col)
                                                        }
                                                    } else {
                                                        selectedPoint = (row: row, col: col)
                                                    }
                                                }
                                            }, label: {
                                                Rectangle()
                                                    .fill(.clear)
                                                    .frame(width: dotSize * 2, height: dotSize * 2)
                                            })
                                        )
                                    }
                                }else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.clear)
                                        .frame(width: dotSize, height: dotSize)
                                        .padding(3)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .containerShape(Rectangle())

            Spacer()

            if knowsLocation {
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(unitCounts.keys.sorted(by: unitSortingOrder), id: \.self) { unit in
                            if let count = unitCounts[unit], count > 0 {
                                HStack(spacing: 5) {
                                    Text("\(count)x")
                                        .contentTransition(.numericText())
                                        .foregroundStyle(redTint)
                                        .fontWeight(.semibold)
                                    Text("\(unitName(for: unit, count: count))") // Handles pluralization
                                }
                                .font(.system(size: 15, weight: .medium, design: .monospaced))
                                .padding(8)
                                .background(.primary.opacity(0.05))
                                .clipShape(.rect(cornerRadius: 10))
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .blur(radius: !knowsLocation ? 5 : 0)
        .overlay(
            VStack {
                Spacer()
                if !knowsLocation {
                    Text("Find out the location first")
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
        )
        .onChange(of: isRunning) {
            if !isRunning {
                stopFlashingMode()
            } else {
                startFlashingMode()
            }
        }
    }

    @State var flashingTimer: Timer?

    func startFlashingMode() {
        flashingTimer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { _ in
            DispatchQueue.main.async {
                activePoint = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                    activePoint = (row: 9, col: 7)
                })
            }
        }
    }

    func stopFlashingMode() {
        flashingTimer?.invalidate()
        flashingTimer = nil
    }

    private var unitCounts: [engineType: Int] {
        Dictionary(grouping: countRespondingUnits, by: { $0 }).mapValues { $0.count }
    }

    private func unitName(for type: engineType, count: Int) -> String {
        switch type {
        case .fireEngine:
            return count > 1 ? "Fire Engines" : "Fire Engine"
        case .secondfireEngine:
            return count > 1 ? "Second Fire Engines" : "Second Fire Engine"
        case .ladderTruck:
            return count > 1 ? "Ladder Trucks" : "Ladder Truck"
        case .commandTruck:
            return count > 1 ? "Command Trucks" : "Command Truck"
        case .ambulance:
            return count > 1 ? "Ambulances" : "Ambulance"
        case .bigambulance:
            return count > 1 ? "Big Ambulances" : "Big Ambulance"
        }
    }

    private let unitSortingOrder: (engineType, engineType) -> Bool = { lhs, rhs in
        let order: [engineType] = [.fireEngine, .secondfireEngine, .ladderTruck, .commandTruck, .ambulance, .bigambulance]
        return order.firstIndex(of: lhs) ?? 0 < order.firstIndex(of: rhs) ?? 0
    }
}

#Preview {
    mapView(selectedPoint: .constant(nil), knowsLocation: .constant(true), countRespondingUnits: .constant([]), isRunning: .constant(false))
}
