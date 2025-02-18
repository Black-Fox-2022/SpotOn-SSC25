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
    @Environment(\.colorScheme) var colorScheme

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

    @State var delayedLocationRequest: Bool = false
    @State var respondingFromCentral: Bool = false

    @State private var feedback1Desc = false

    @State private var feedback2 = false
    @State private var feedback2Desc = false

    @State private var feedback3 = false
    @State private var feedback3Desc = false

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
                    SoundManager.shared.playSound(type: .buttonPrimary)
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
                .background(isRunning ? .secondary.opacity(0.5) : orangeTint)
                .clipShape(.rect(cornerRadius: 10))
                .disabled(isRunning)
            }
            .padding(10)
            .background(.primary.opacity(0.05))
            .clipShape(.rect(cornerRadius: 15))
            .padding(.horizontal, 35)
            .offset(y: topBarOffset)

            HStack (spacing: 12){

                conversationView(knowsLocation: $knowsLocation, delayedLocationRequest: $delayedLocationRequest)
                    .opacity(!isRunning ? 0.3 : 1.0)
                    .overlay(
                        VStack {
                            if !isRunning && !tutorialSheet{
                                VStack(alignment: .leading) {
                                    TypeWriterText(.constant(callerFeedbackTitle))
                                        .foregroundStyle(orangeTint)
                                        .frame(width: 400, alignment: .leading)
                                    if feedback1Desc {
                                        TypeWriterText(.constant(callerFeedbackDescription))
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                .frame(width: 400)
                                .font(.system(size: 16, weight: .semibold, design: .monospaced))
                                .onAppear{
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.25, execute: {
                                        withAnimation(.bouncy) {
                                            feedback1Desc = true
                                        } completion: {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                                                withAnimation(.bouncy) {
                                                    feedback2 = true
                                                }
                                            })
                                        }
                                    })
                                }
                            }
                        }
                    )
                    .offset(x: conversationOffset)

                VStack (spacing: 12){

                    VStack {
                        HStack {
                            mapView(selectedPoint: $selectedPoint, knowsLocation: $knowsLocation, countRespondingUnits: $countRespondingUnits)
                                .frame(width: 400)
                        }
                    }
                    .padding()
                    .frame(width: 575)
                    .background(.primary.opacity(0.05))
                    .clipShape(.rect(cornerRadius: 15))
                    .opacity(!isRunning ? 0.3 : 1.0)
                    .overlay(
                        VStack {
                            if !isRunning && feedback3 && !tutorialSheet{
                                VStack (alignment: .leading){
                                    TypeWriterText(.constant(stationFeedbackTitle))
                                        .foregroundStyle(orangeTint)
                                        .frame(width: 400, alignment: .leading)
                                    if feedback3Desc {
                                        TypeWriterText(.constant(stationFeedbackDescription))
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                .frame(width: 400)
                                .font(.system(size: 16, weight: .semibold, design: .monospaced))
                                .onAppear{
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.25, execute: {
                                        withAnimation(.bouncy) {
                                            feedback3Desc = true
                                        }
                                    })
                                }
                            }
                        }
                    )
                    .offset(x: mapOffset)

                    stationView(selectedPoint: $selectedPoint, countRespondingUnits: $countRespondingUnits, respondingFromCentral: $respondingFromCentral)
                        .opacity(!isRunning ? 0.3 : 1.0)
                        .overlay(
                            VStack {
                                if !isRunning && feedback2 && !tutorialSheet{
                                    VStack (alignment: .leading){
                                        TypeWriterText(.constant(unitFeedbackTitle))
                                            .foregroundStyle(orangeTint)
                                            .frame(width: 400, alignment: .leading)
                                        if feedback2Desc {
                                            TypeWriterText(.constant(unitFeedbackDescription))
                                                .multilineTextAlignment(.leading)
                                        }
                                    }
                                    .frame(width: 400)
                                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                                    .onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                            withAnimation(.bouncy) {
                                                feedback2Desc = true
                                            } completion: {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 7.0, execute: {
                                                    withAnimation(.bouncy) {
                                                        feedback3 = true
                                                    }
                                                })
                                            }
                                        })
                                    }
                                }
                            }
                        )
                        .offset(y: stationOffset)

                }
                .padding(.trailing, 35)
            }
            .disabled(!isRunning)
        }
        .onChange(of: isRunning) {
            if !isRunning {
                selectedPoint = nil
            }
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
                    SoundManager.shared.playSound(type: .buttonPrimary)
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

    private var callerFeedbackTitle: String {
        return delayedLocationRequest ? "You could have been faster!" : "Amazing!"
    }

    private var callerFeedbackDescription: String {
        return delayedLocationRequest
            ? "You responded well, but you should have asked for the location earlier!"
            : "You asked all the right questions and handled the call perfectly!"
    }

    private var stationFeedbackTitle: String {
        return respondingFromCentral ? "Great choices!" : "Not the best option..."
    }

    private var stationFeedbackDescription: String {
        return respondingFromCentral
            ? "You dispatched units from the central fire station, ensuring a fast response!"
            : "You selected units from a distant fire station. A closer one would have been faster."
    }

    private var unitFeedbackTitle: String {
        let ideal = isIdealUnitSelection()
        return ideal ? "Perfect unit selection!" : "Good choices, but could be improved!"
    }

    private var unitFeedbackDescription: String {
        var messages: [String] = []

        let fireEngines = countRespondingUnits.filter { $0 == .fireEngine || $0 == .secondfireEngine }.count
        let ladders = countRespondingUnits.filter { $0 == .ladderTruck }.count
        let ambulances = countRespondingUnits.filter { $0 == .ambulance || $0 == .bigambulance }.count
        let commandTrucks = countRespondingUnits.filter { $0 == .commandTruck }.count

        if fireEngines >= 2{
            messages.append(ladders >= 1 ? "You sent out a good number of fire engines and your ladder truck selection was spot on!" : "You sent out a good number of fire engines, but a ladder truck would have been very useful as well.")
        } else {
            messages.append(ladders >= 1 ? "You could have sent at least 2 fire engines for a better response, but your ladder truck selection was spot on!" : "You could have sent at least 2 fire engines for a better response and a ladder truck would have been very useful as well.")
        }

        if ambulances >= 1 && ambulances <= 2 {
            messages.append("Good decision including an ambulance.")
        } else {
            messages.append("Consider sending an ambulance for safety.")

        }

        if commandTrucks == 1 {
            messages.append("A command truck is useful for coordination — good job!")
        } else {
            messages.append(commandTrucks == 0
                ? "A command truck would have helped coordinate efforts better."
                : "One command truck is usually enough for managing an incident.")

        }

        return messages.joined(separator: " \n")
    }

    // ✅ Checks if the unit selection is ideal
    private func isIdealUnitSelection() -> Bool {
        let fireEngines = countRespondingUnits.filter { $0 == .fireEngine || $0 == .secondfireEngine }.count
        let ladders = countRespondingUnits.filter { $0 == .ladderTruck }.count
        let ambulances = countRespondingUnits.filter { $0 == .ambulance || $0 == .bigambulance }.count
        let commandTrucks = countRespondingUnits.filter { $0 == .commandTruck }.count

        return (fireEngines >= 2 && fireEngines <= 3) &&
               (ladders >= 1 && ladders <= 2) &&
               (ambulances >= 1 && ambulances <= 2) &&
               (commandTrucks == 1)
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
            .foregroundColor(remainingTime < 0.02 ? .red : remainingTime < 10 ? (flashRed ? .red : .primary) : .primary)
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
                    SoundManager.shared.playSound(type: .countDown)
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
    Mission_CallResponder(currentMode: .constant(.level))
}
