//
//  SubView_TutorialSheet.swift
//  FireKIt
//
//  Created by Lukas on 19.02.25.
//

import SwiftUI


struct TutorialSheet: View {
    @Binding var isRunning: Bool
    @Binding var tutorialSheet: Bool

    @State var finishingIsBlocked: Bool = true

    var body: some View {
        VStack(alignment: .center, spacing: 10) {

            Text("Your Mission - Be a Dispatcher")
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .multilineTextAlignment(.center)

            Text("In this mission, you'll step into the role of an emergency dispatcher. \nYou'll learn why being clear, direct, and precise is crucial when calling 911.")
                .font(.system(size: 18,weight: .medium, design: .monospaced))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Spacer()

            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "person.wave.2")
                        .foregroundColor(redTint)
                        .font(.system(size: 26))
                        .frame(width: 60)
                    VStack(alignment: .leading) {
                        Text("Communicate with the caller")
                            .font(.system(size: 20, weight: .semibold, design: .monospaced))
                        Text("Choose the right questions and gather key details")
                            .font(.system(size: 16, weight: .regular, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .lineLimit(2, reservesSpace: true)
                    }
                }

                HStack {
                    Image(systemName: "dot.viewfinder")
                        .foregroundColor(redTint)
                        .font(.system(size: 26))
                        .frame(width: 60)
                    VStack(alignment: .leading) {
                        Text("Choose the right stations")
                            .font(.system(size: 20, weight: .semibold, design: .monospaced))
                        Text("There are two fire stations and one rescue station in the area")
                            .font(.system(size: 16, weight: .regular, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .lineLimit(2, reservesSpace: true)
                    }
                }

                HStack {
                    Image(systemName: "light.beacon.max")
                        .foregroundColor(redTint)
                        .font(.system(size: 26))
                        .frame(width: 60)
                    VStack(alignment: .leading) {
                        Text("Deploy the right units")
                            .font(.system(size: 20, weight: .semibold, design: .monospaced))
                        Text("Decide which types of units could be useful")
                            .font(.system(size: 16, weight: .regular, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .lineLimit(2, reservesSpace: true)
                    }
                }

                HStack {
                    Image(systemName: "60.arrow.trianglehead.counterclockwise")
                        .foregroundColor(redTint)
                        .font(.system(size: 25))
                        .frame(width: 60)
                    VStack(alignment: .leading) {
                        Text("Act fast – You have 60 seconds!")
                            .font(.system(size: 20, weight: .semibold, design: .monospaced))
                        Text("Every second counts in a real emergency")
                            .font(.system(size: 16, weight: .regular, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .lineLimit(1, reservesSpace: true)
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
                HStack (spacing: 20){
                    if finishingIsBlocked {
                        TimerCircleView(isRunning: $finishingIsBlocked)
                    }
                    Text("Start Mission")
                }
                .font(.system(size: 18, weight: .semibold, design: .monospaced))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(finishingIsBlocked ? .secondary.opacity(0.4) : redTint)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 40)
            }
            .disabled(finishingIsBlocked)
        }
        .padding(30)
        .interactiveDismissDisabled()
    }
}

struct TimerCircleView: View {
    @Binding var isRunning: Bool

    @State private var remainingTime: CGFloat = 6.0
    private let totalTime: CGFloat = 5.0

    private var progress: CGFloat {
        return remainingTime / totalTime
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .opacity(0.1)
                .foregroundColor(.white)

            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .foregroundColor(.white)
        }
        .frame(width: 15, height: 15)
        .rotationEffect(Angle(degrees: 270.0))
        .onAppear {
            isRunning = true
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if remainingTime > 0 {
                    withAnimation(.easeInOut) {
                        remainingTime -= 1
                    }
                } else {
                    withAnimation(.easeInOut) {
                        isRunning = false
                    }
                    timer.invalidate()
                }
            }
        }
    }
}

#Preview {
    TutorialSheet(isRunning: .constant(false), tutorialSheet: .constant(true))
}
