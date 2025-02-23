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
    @State private var remainingTime: TimeInterval = 60.00
    @State private var shakeTrigger: CGFloat = 0
    @State private var knowsLocation: Bool = false

    @State private var tutorialSheet: Bool = true
    @State private var infoSheet: Bool = false
    @State private var isExiting = false

    @State private var topBarOffset: CGFloat = 0
    @State private var conversationOffset: CGFloat = 0
    @State private var mapOffset: CGFloat = 0
    @State private var stationOffset: CGFloat = 0

    @State var delayedLocationRequest: Bool = false
    @State var askedForPastaType: Bool = false
    @State var respondingFromCentral: Bool = false

    @State private var feedback1Desc = false

    @State private var feedback2 = false
    @State private var feedback2Desc = false

    @State private var feedback3 = false
    @State private var feedback3Desc = false

    var allowEarlyMissionEnding: Bool {
        return countRespondingUnits.count >= 4 && isRunning && remainingTime <= 30.0 && knowsLocation
    }

    var body: some View {
        VStack (spacing: 12){
            HStack {
                TimerText(isRunning: $isRunning, timeLeft: $remainingTime)

                Spacer()

                HStack (spacing: 0) {
                    Text("Mission")
                        .foregroundStyle(redTint)
                    Text(" Dispatcher")
                        .foregroundStyle(.primary.opacity(0.8))
                    Button(action: {
                        infoSheet.toggle()
                    }, label: {
                        Image(systemName: "info.circle")
                            .fontWeight(.regular)
                    })
                    .padding(.leading, 6)
                    .foregroundStyle(.secondary)

                }
                .font(.system(size: 18, weight: .bold, design: .monospaced))

                Spacer()

                Button(action: {
                    if isRunning {
                        SoundManager.shared.playSound(type: .buttonPrimary)
                        withAnimation(.spring) {
                            isRunning = false
                        }
                    }else {
                        successFeedback()
                        SoundManager.shared.playSound(type: .buttonPrimary)
                        withAnimation(.spring) {
                            isRunning = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            exitAnimation()
                        }
                    }
                }, label: {
                    HStack {
                        Text(isRunning ? "End Call" : "Finish Mission")

                        if allowEarlyMissionEnding {
                            Image(systemName: "phone.down.fill")
                        }else if !isRunning {
                            Image(systemName: "arrow.right.to.line")
                        }
                    }
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .animation(.spring, value: allowEarlyMissionEnding)
                })
                .background(isRunning && !allowEarlyMissionEnding ? .secondary.opacity(0.4) : redTint)
                .clipShape(.rect(cornerRadius: 8))
                .disabled(isRunning && !allowEarlyMissionEnding)
                .modifier(ShakeEffect(animatableData: shakeTrigger))
                .onTapGesture {
                    if isRunning {
                        withAnimation(.bouncy(duration: 0.75)) {
                            shakeTrigger += 1
                        }
                    }
                }
            }
            .padding(10)
            .background(.primary.opacity(0.05))
            .clipShape(.rect(cornerRadius: 15))
            .padding(.top, 10)
            .padding(.horizontal, 35)
            .offset(y: topBarOffset)

            HStack (spacing: 12){

                conversationView(knowsLocation: $knowsLocation, delayedLocationRequest: $delayedLocationRequest, askedForPastaType: $askedForPastaType)
                    .opacity(!isRunning ? 0.25 : 1.0)
                    .overlay(
                        VStack {
                            if !isRunning && !tutorialSheet{
                                VStack(alignment: .leading) {
                                    TypeWriterText(.constant(callerFeedbackTitle), delay: 0.75)
                                        .foregroundStyle(redTint)
                                        .frame(width: 400, alignment: .leading)
                                    if feedback1Desc {
                                        TypeWriterText(.constant(callerFeedbackDescription), delay: 0.5)
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
                            mapView(selectedPoint: $selectedPoint, knowsLocation: $knowsLocation, countRespondingUnits: $countRespondingUnits, isRunning: $isRunning)
                        }
                    }
                    .padding()
                    .frame(width: 575)
                    .background(.primary.opacity(0.05))
                    .clipShape(.rect(cornerRadius: 15))
                    .opacity(!isRunning ? 0.25 : 1.0)
                    .overlay(
                        VStack {
                            if !isRunning && feedback3 && !tutorialSheet{
                                VStack (alignment: .leading){
                                    TypeWriterText(.constant(stationFeedbackTitle), delay: 0.75)
                                        .foregroundStyle(redTint)
                                        .frame(width: 400, alignment: .leading)
                                    if feedback3Desc {
                                        TypeWriterText(.constant(stationFeedbackDescription), delay: 0.5)
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
                        .opacity(!isRunning ? 0.25 : 1.0)
                        .overlay(
                            VStack {
                                if !isRunning && feedback2 && !tutorialSheet{
                                    VStack (alignment: .leading){
                                        TypeWriterText(.constant(unitFeedbackTitle), delay: 0.75)
                                            .foregroundStyle(redTint)
                                            .frame(width: 400, alignment: .leading)
                                        if feedback2Desc {
                                            TypeWriterText(.constant(unitFeedbackDescription), delay: 0.5)
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
            TutorialSheet(isRunning: $isRunning, tutorialSheet: $tutorialSheet)
        })
        .sheet(isPresented: $infoSheet, content: {
            TutorialSheet(isRunning: $isRunning, tutorialSheet: $infoSheet, isReshown: true)
        })
        //.redacted(reason: .placeholder)
    }

    private var callerFeedbackTitle: String {
        return delayedLocationRequest ? "You could have been faster!" : "Amazing!"
    }

    private var callerFeedbackDescription: String {
        return delayedLocationRequest
        ? (askedForPastaType ? "You responded ok, but you should have asked for the location earlier and maybe the pasta type wasn't that important!" : "You responded well, but you should have asked for the location earlier!")
        : (askedForPastaType ? "Very good, but maybe asking for the pasta type isn't that important." : "You asked all the right questions and handled the call perfectly!")
    }

    private var stationFeedbackTitle: String {
        return respondingFromCentral ? "Great choices!" : "Not the best option..."
    }

    private var stationFeedbackDescription: String {
        return respondingFromCentral
            ? "You dispatched units from the central fire station, ensuring a fast response!"
            : "You mainly selected units from the fire station further away, the other one would've been faster!"
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
            messages.append(ladders >= 1 ? "You sent out a good number of fire engines and 1-2 ladders are fine too." : "You sent out a good number of fire engines, but 1-2 ladder trucks would have been very useful as well.")
        } else {
            messages.append(ladders >= 1 ? "You could have sent at least 2 fire engines for a better response, but your ladder truck selection was spot on!" : "You could have sent at least 2 fire engines for a better response and a ladder truck would have been very useful as well.")
        }

        if ambulances == 1 {
            messages.append("Good decision including an ambulance, maybe one more would've been even better.")
        }else if ambulances == 2 {
            messages.append("Very good idea to send 2 ambulances, better safe than sorry!")
        } else {
            messages.append("Consider sending an ambulance for safety.")

        }

        if commandTrucks == 1 {
            messages.append("A command truck is very useful for coordination — good job!")
        } else {
            messages.append("A command vehicle would have helped with coordination.")

        }

        return messages.joined(separator: " \n")
    }

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

enum engineStatus {
    case responding
    case inStation
}

#Preview {
    Mission_CallResponder(currentMode: .constant(.level))
}
