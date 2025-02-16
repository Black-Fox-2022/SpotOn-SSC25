//
//  conversationView.swift
//  SSC_2025
//
//  Created by Lukas on 09.02.25.
//

import SwiftUI

struct conversationView: View {
    @Binding var knowsLocation: Bool

    let conversation: Conversation = Conversation(
        initialMessage: "Hello! Please, I need help fast.",
        steps: [

            // Step 1: Address / Location Clarification
            ConversationStep(options: [
                ResponderOption(
                    text: "What is your address?",
                    callerReply: "I live at New Park Avenue 23."
                    // ✅ Precise and useful – gets emergency responders to the location fast.
                ),
                ResponderOption(
                    text: "Are you in a safe place?",
                    callerReply: "I’m outside, but my house is burning!"
                    // ⚠️ Gives context but doesn’t provide location immediately.
                ),
                ResponderOption(
                    text: "Where are you right now?",
                    callerReply: "I'm at home."
                    // ❌ Not helpful – responders don’t know where ‘home’ is.
                )
            ]),

            // Step 2: Identifying the Emergency
            ConversationStep(options: [
                ResponderOption(
                    text: "What’s the emergency?",
                    callerReply: "My kitchen is on fire!"
                    // ✅ Clearly describes the situation.
                ),
                ResponderOption(
                    text: "Do you need medical help?",
                    callerReply: "No, it’s a fire emergency!"
                    // ❌ Not directly useful – asking this too early may waste time.
                ),
                ResponderOption(
                    text: "What happened?",
                    callerReply: "I was cooking, and now my kitchen is burning."
                    // ⚠️ Less direct but still useful.
                )
            ]),

            // Step 3: Clarifying the Fire's Impact
            ConversationStep(options: [
                ResponderOption(
                    text: "Is the fire spreading?",
                    callerReply: "Yes, it’s moving beyond the kitchen!"
                ),
                ResponderOption(
                    text: "Is there smoke outside?",
                    callerReply: "There’s thick black smoke coming from the roof!"
                ),
                ResponderOption(
                    text: "What is your address?",
                    callerReply: "I live at New Park Avenue 23."
                )
            ]),

            // Step 4: Safety Confirmation
            ConversationStep(options: [
                ResponderOption(
                    text: "Are you safe outside?",
                    callerReply: "Yes, I’m standing on the street."
                    // ✅ Confirms safety.
                ),
                ResponderOption(
                    text: "Can you check inside?",
                    callerReply: "No way, it’s way too dangerous!"
                    // ❌ Dangerous suggestion.
                ),
                ResponderOption(
                    text: "Is anyone else inside?",
                    callerReply: "No, I’m alone."
                    // ✅ Important for search & rescue.
                )
            ]),

            // Step 5: Final Confirmation
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
                            Spacer(minLength: 200)
                        }
                        .scrollIndicators(.hidden)
                        .onChange(of: messages.count) { _ in
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

                                        if option.text.contains("address") {
                                            knowsLocation = true
                                        }

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                            withAnimation(.spring) {
                                                messages.append(Message(text: option.callerReply, isIncoming: true))
                                                currentStep += 1
                                                preventAction = false

                                                if currentStep >= 4 && !knowsLocation {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                        withAnimation(.spring) {
                                                            messages.append(Message(text: "By the way, I live at New Park Avenue 23.", isIncoming: true))
                                                            knowsLocation = true
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
                        .background(.primary.opacity(0.05))
                        .background(.primary.opacity(0.05))
                        .background(.primary.opacity(0.1))
                        .background(.background)
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
                    .background(orangeTint)
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
                    .foregroundStyle(isIncoming ? colorScheme == .light ? .black : .white : orangeTint)
                if isIncoming {
                    //Spacer(minLength: 1)
                }
            }
            .padding()
            .background(isIncoming ? colorScheme == .light ? .black.opacity(0.1) : .white.opacity(0.1) : orangeTint.opacity(0.25))
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
