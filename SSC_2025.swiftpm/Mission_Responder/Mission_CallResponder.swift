//
//  SwiftUIView.swift
//  SSC_2025
//
//  Created by Lukas on 08.02.25.
//

import SwiftUI
import MapKit
import AVFoundation

struct Mission_CallResponder: View {
    @State var isRunning: Bool = false
    @State var knowsLocation: Bool = false

    @State var selectedPoint: (row: Int, col: Int)? = nil
    @State var countRespondingUnits: [engineType] = []

    @State var tutorialSheet: Bool = true

    var body: some View {
        VStack (spacing: 12){
            HStack {
                TimerText(isRunning: $isRunning)

                Spacer()

                HStack (spacing: 0) {
                    Text("Dispatcher ")
                        .foregroundStyle(.primary.opacity(0.8))
                    Text("Mission II")
                        .foregroundStyle(orangeTint)
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
                .disabled(countRespondingUnits.count < 1)
            }
            .padding(10)
            .background(.primary.opacity(0.05))
            .clipShape(.rect(cornerRadius: 15))
            .padding(.horizontal, 35)

            HStack (spacing: 12){

                conversationView(knowsLocation: $knowsLocation)

                VStack (spacing: 12){

                    VStack {
                        HStack {
                            mapView(selectedPoint: $selectedPoint, knowsLocation: $knowsLocation)
                                .frame(width: 400)

                        }
                    }
                    .padding()
                    .frame(width: 575)
                    .background(.primary.opacity(0.05))
                    .clipShape(.rect(cornerRadius: 15))

                    stationView(selectedPoint: $selectedPoint, countRespondingUnits: $countRespondingUnits)


                }
                .padding(.trailing, 35)
            }
        }
        .sheet(isPresented: $tutorialSheet, content: {
            VStack(alignment: .center, spacing: 10) {

                Text("Mission II - Be a Dispatcher")
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .multilineTextAlignment(.center)

                Text("In this mission, you will be get to know how it is like to respond to an emergency call. \nYou will learn why it's important to be direct and precise when calling 911.")
                    .font(.system(size: 18,weight: .medium, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Spacer()

                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "person.wave.2.fill")
                            .foregroundColor(orangeTint)
                            .font(.system(size: 24))
                            .frame(width: 60)
                        VStack(alignment: .leading) {
                            Text("Talk to the caller")
                                .font(.system(size: 20, weight: .semibold, design: .monospaced))
                            Text("Find out all necessary information")
                                .font(.system(size: 16, weight: .regular, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                    }

                    HStack {
                        Image(systemName: "car.2.fill")
                            .foregroundColor(orangeTint)
                            .font(.system(size: 24))
                            .frame(width: 60)
                        VStack(alignment: .leading) {
                            Text("Decide which units to send")
                                .font(.system(size: 20, weight: .semibold, design: .monospaced))
                            Text("Choose the correct emergency response")
                                .font(.system(size: 16, weight: .regular, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                    }

                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(orangeTint)
                            .font(.system(size: 24))
                            .frame(width: 60)
                        VStack(alignment: .leading) {
                            Text("Be fast – You have 45 seconds!")
                                .font(.system(size: 20, weight: .semibold, design: .monospaced))
                            Text("In real life, time is critical")
                                .font(.system(size: 16, weight: .regular, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()

                Button(action: {
                    tutorialSheet = false
                    isRunning = true
                }) {
                    Text("Start Mission")
                        .font(.system(size: 18, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(orangeTint)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 40)
                }
            }
            .padding(30)
            .interactiveDismissDisabled()
        })
        //.redacted(reason: .placeholder)
    }
}

struct TimerText: View {
    @Binding var isRunning: Bool
    @State private var remainingTime: TimeInterval = 45.00
    @State private var timer: Timer? = nil
    @State private var flashTimer: Timer? = nil // Separate timer for flashing effect

    @State private var startedRedFlash = false
    @State private var flashRed = false

    var body: some View {
        Text(formattedTime)
            .font(.system(size: 20, weight: .semibold, design: .monospaced))
            .foregroundColor(remainingTime < 10 ? (flashRed ? .red : .white) : .primary)
            .padding(.horizontal)
            .onChange(of: isRunning) {
                if isRunning {
                    startTimer()
                } else {
                    stopTimer()
                }
            }
    }

    private func startTimer() {
        timer?.invalidate() // Reset main timer
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 0.01

                if remainingTime < 10 && !startedRedFlash {
                    startedRedFlash = true
                    startFlashing()
                }
            } else {
                stopTimer()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        flashTimer?.invalidate()
        flashTimer = nil
        isRunning = false
    }

    private func startFlashing() {
        flashTimer?.invalidate()
        flashTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                withAnimation(.spring) {
                    flashRed.toggle()
                }
            }
        }
    }

    private var formattedTime: String {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        let centiseconds = Int((remainingTime - Double(Int(remainingTime))) * 100)
        return String(format: "%02d.%02d.%02d", minutes, seconds, centiseconds)
    }
}

enum engineStatus {
    case responding
    case inStation
}

#Preview {
    Mission_CallResponder()
}
