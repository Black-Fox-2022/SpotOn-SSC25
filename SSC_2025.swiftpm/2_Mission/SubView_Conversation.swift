//
//  conversationView.swift
//  SSC_2025
//
//  Created by Lukas on 09.02.25.
//

import SwiftUI

struct conversationView: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var knowsLocation: Bool
    @Binding var delayedLocationRequest: Bool
    @Binding var askedForPastaType: Bool
    @Binding var askedIfGoInside: Bool

    let conversation: Conversation = Conversation(
        initialMessage: "Hello! Please, I need help fast.",
        steps: [
            ConversationStep(options: [
                ResponderOption(
                    text: "What is your address?",
                    callerReply: "I live at New Park Avenue 23."
                ),
                ResponderOption(
                    text: "Are you in a safe place?",
                    callerReply: "I'm outside, but my house is burning!"
                ),
                ResponderOption(
                    text: "Where are you right now?",
                    callerReply: "I'm at home."
                )
            ]),

            ConversationStep(options: [
                ResponderOption(
                    text: "Can I have your name?",
                    callerReply: "This is Sarah."
                ),
                ResponderOption(
                    text: "Who is calling?",
                    callerReply: "It's Sarah."
                ),
                ResponderOption(
                    text: "Do you have pets?",
                    callerReply: "Yes, I have two cats, but they are with me."
                )
            ]),

            ConversationStep(options: [
                ResponderOption(
                    text: "What happened?",
                    callerReply: "I was cooking and trying to make pasta, and now everything's burning."
                ),
                ResponderOption(
                    text: "What’s the emergency?",
                    callerReply: "My pasta is on fire!"
                ),
                ResponderOption(
                    text: "What is your address?",
                    callerReply: "I live at New Park Avenue 23."
                )
            ]),

            ConversationStep(options: [
                ResponderOption(
                    text: "Which pasta were you making?",
                    callerReply: "Spaghetti, but that's not important now!"
                ),
                ResponderOption(
                    text: "Is the fire spreading?",
                    callerReply: "Yes, it's moving beyond the kitchen!"
                ),
                ResponderOption(
                    text: "Is there smoke outside?",
                    callerReply: "Thick black smoke is coming from the window!"
                )
            ]),

            ConversationStep(options: [
                ResponderOption(
                    text: "Are you safe outside?",
                    callerReply: "Yes, I'm standing on the street."
                ),
                ResponderOption(
                    text: "Can you check inside?",
                    callerReply: "No, that's way too dangerous!"
                ),
                ResponderOption(
                    text: "Is anyone else in the building?",
                    callerReply: "Maybe, I am not sure if all neighbors are out."
                )
            ]),

            ConversationStep(options: [
                ResponderOption(
                    text: "Stay safe, help is on the way!",
                    callerReply: "Thank you!"
                )
            ])
        ]
    )

    @State private var messages: [Message] = []
    @State private var currentStep: Int = 0
    @State private var preventAction: Bool = false

    var body: some View {
        VStack (spacing: 10){
            ZStack (alignment: .bottom) {
                VStack (alignment: .leading, spacing: 10){
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack (spacing: 15){
                                ForEach(messages) { message in
                                    textBubble(text: message.text, isIncoming: message.isIncoming)
                                        .id(message.id)
                                }
                            }
                            Spacer(minLength: 150)
                        }
                        .scrollIndicators(.hidden)
                        .onChange(of: messages.count) {
                            if messages.count > 0 {
                                withAnimation(.easeOut) {
                                    proxy.scrollTo(messages.last?.id, anchor: .top)
                                }
                            }
                        }
                    }

                    Spacer()
                }
                .padding()
                .frame(maxHeight: .infinity)
                .background(.primary.opacity(0.05))
                .clipShape(.rect(cornerRadius: 15))

                if currentStep < conversation.steps.count {
                    VStack(spacing: 8) {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(conversation.steps[currentStep].options) { option in
                                    Button(action: {
                                        messages.append(Message(text: option.text, isIncoming: false))
                                        preventAction = true
                                        SoundManager.shared.playSound(type: .buttonSecondary)
                                        lightFeedback()
                                        
                                        if option.text.contains("address") {
                                            knowsLocation = true
                                        }

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                            withAnimation(.spring) {
                                                messages.append(Message(text: option.callerReply, isIncoming: true))
                                                currentStep += 1
                                                preventAction = false

                                                if currentStep == 3 && option.text.contains("Which pasta") {
                                                    askedForPastaType = true
                                                }

                                                if option.text.contains("Can you check inside") {
                                                    askedIfGoInside = true
                                                }

                                                if currentStep >= 4 && !knowsLocation {
                                                    delayedLocationRequest = true
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                                            messages.append(Message(text: "By the way, I live at New Park Avenue 23.", isIncoming: true))
                                                            knowsLocation = true
                                                    }
                                                }
                                                if currentStep == 6 {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                        withAnimation(.spring) {
                                                            messages.append(Message(text: "I am never gonna make pasta again!", isIncoming: true))
                                                        }
                                                    }
                                                }
                                            }
                                        })
                                    }) {
                                        answerOption(text: option.text)
                                    }
                                }
                            }
                            .padding(10)
                            .disabled(preventAction)
                        }
                        .padding(.horizontal, 1)
                        .scrollIndicators(.hidden)
                        .background(.primary.opacity(0.1))
                        .background(.primary.opacity(0.1))
                        .background(colorScheme == .light ? .white : .black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(10)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.leading, 35)
        .onAppear {
            messages.append(Message(text: conversation.initialMessage, isIncoming: true))
        }
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
                    .background(redTint)
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
                    .foregroundStyle(isIncoming ? colorScheme == .light ? .black : .white : redTint)
            }
            .padding()
            .background(isIncoming ? colorScheme == .light ? .black.opacity(0.1) : .white.opacity(0.1) : redTint.opacity(0.25))
            .clipShape(.rect(cornerRadius: 10))

            if isIncoming {
                Spacer(minLength: 125)
            }
        }
    }
}


struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isIncoming: Bool
}

struct ResponderOption: Identifiable {
    let id = UUID()
    let text: String
    let callerReply: String
}

struct ConversationStep {
    let options: [ResponderOption]
}

struct Conversation {
    let initialMessage: String
    let steps: [ConversationStep]
}
