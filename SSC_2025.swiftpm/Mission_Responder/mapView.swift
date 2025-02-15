//
//  SwiftUIView.swift
//  SSC_2025
//
//  Created by Lukas on 09.02.25.
//

import SwiftUI

struct mapView: View {

    @Binding var selectedPoint: (row: Int, col: Int)?


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


    let dotSize: CGFloat = 9
    let spacing: CGFloat = 6

    @State private var activePoint: (row: Int, col: Int)? = (row: 9, col: 7)
    @State private var fadingPoint: (row: Int, col: Int)? = nil
    
    @State private var emergencyLocation: String = ""

    var body: some View {
        VStack {

           /* HStack {
                Text("Responder Options")
                    .font(.system(size: 22, weight: .bold, design: .monospaced))
                Spacer()
                /*TextField("Enter location", text: $emergencyLocation)
                    .padding(.horizontal)
                    .frame(height: 40)
                    .background(Color.primary.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(width: 200)

                Button(action: {

                }, label: {
                    Image(systemName: "checkmark")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                })
                .background(Color(hex: 0xf96407))
                .clipShape(RoundedRectangle(cornerRadius: 10))*/
            }
*/
           // Spacer()

            HStack {
                Spacer()
                VStack(spacing: spacing) {
                    ForEach(0..<localMatrix.count, id: \.self) { row in
                        HStack(spacing: spacing) {
                            ForEach(0..<localMatrix[row].count, id: \.self) { col in
                                if localMatrix[row][col] == 1 {
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

                                        if activePoint?.row == row && activePoint?.col == col {
                                            EmergencyRipple(dotSize: dotSize)
                                        }
                                    }
                                } else if localMatrix[row][col] == 2 {
                                    Button(action: {
                                        print("tapped on fire station")
                                        withAnimation(.spring) {
                                            if let point = selectedPoint {
                                                if point == (row: row, col: col) {
                                                    selectedPoint = nil
                                                    print("point: \(selectedPoint)")
                                                }else {
                                                    selectedPoint = (row: row, col: col)
                                                }
                                            } else {
                                                selectedPoint = (row: row, col: col)
                                            }
                                        }
                                    }, label: {
                                        if let selectedPoint = selectedPoint, selectedPoint.row == row && selectedPoint.col == col {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.blue)
                                                .frame(width: dotSize, height: dotSize)
                                        }else {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.blue.opacity(0.5))
                                                .frame(width: dotSize, height: dotSize)
                                        }
                                    })
                                    .containerShape(Rectangle())
                                }else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.clear)
                                        .frame(width: dotSize, height: dotSize)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }

            Spacer()
        }
        .padding()
        .onAppear{
            startFlashingMode()
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
}

#Preview {
    mapView(selectedPoint: .constant(nil))
}
