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
    @Binding var currentMode: Mode

    @State var selectedPoint: (row: Int, col: Int)? = nil
    @State var countRespondingUnits: [engineType] = []

    @State private var isRunning: Bool = false
    @State private var knowsLocation: Bool = false

    @State private var tutorialSheet: Bool = true
    @State private var isExiting = false

    @State private var topBarOffset: CGFloat = 0
    @State private var conversationOffset: CGFloat = 0
    @State private var mapOffset: CGFloat = 0
    @State private var stationOffset: CGFloat = 0

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
                    successFeedback()
                    withAnimation(.spring) {
                        isRunning = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        exitAnimation()
                    }
                }, label: {
                    Text("Finish Mission")
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                })
                .background(/*countRespondingUnits.count < 1 && */isRunning ? .secondary.opacity(0.5) : orangeTint)
                .clipShape(.rect(cornerRadius: 10))
                .disabled(/*countRespondingUnits.count < 1 && */isRunning)
            }
            .padding(10)
            .background(.primary.opacity(0.05))
            .clipShape(.rect(cornerRadius: 15))
            .padding(.horizontal, 35)
            .offset(y: topBarOffset)

            HStack (spacing: 12){

                conversationView(knowsLocation: $knowsLocation)
                    .offset(x: conversationOffset)

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
                    .offset(x: mapOffset)
                    stationView(selectedPoint: $selectedPoint, countRespondingUnits: $countRespondingUnits)
                        .offset(y: stationOffset)

                }
                .padding(.trailing, 35)
            }
            .opacity(!isRunning ? 0.5 : 1.0)
            .disabled(!isRunning)
        }
        .sheet(isPresented: $tutorialSheet, content: {
            VStack(alignment: .center, spacing: 10) {

                Text("Mission II - Be a Dispatcher")
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .multilineTextAlignment(.center)

                Text("In this mission, you'll step into the role of an emergency dispatcher. \nYou'll learn why being clear, direct, and precise is crucial when calling 911.")
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
                            Text("Communicate with the caller")
                                .font(.system(size: 20, weight: .semibold, design: .monospaced))
                            Text("Choose the right questions and gather key details")
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
                            Text("Deploy the right units")
                                .font(.system(size: 20, weight: .semibold, design: .monospaced))
                            Text("Decide which types of units could be useful")
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
                            Text("Act fast – You have 45 seconds!")
                                .font(.system(size: 20, weight: .semibold, design: .monospaced))
                            Text("Every second counts in a real emergency")
                                .font(.system(size: 16, weight: .regular, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()

                Button(action: {
                    mediumFeedback()
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

    private func exitAnimation() {
        withAnimation(.spring()) {
            isRunning = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.8)) {
                topBarOffset = -UIScreen.main.bounds.height / 2
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeInOut(duration: 0.8)) {
                conversationOffset = -UIScreen.main.bounds.width
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeInOut(duration: 0.8)) {
                mapOffset = UIScreen.main.bounds.width
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeInOut(duration: 0.8)) {
                stationOffset = UIScreen.main.bounds.height / 2
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            currentMode = .end
        }
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
            .frame(width: 100, alignment: .leading)
            .font(.system(size: 20, weight: .semibold, design: .monospaced))
            .foregroundColor(remainingTime == 0 ? .red : remainingTime < 10 ? (flashRed ? .red : .white) : .primary)
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
        RunLoop.current.add(timer!, forMode: .common)
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
    Mission_CallResponder(currentMode: .constant(.level1))
}
