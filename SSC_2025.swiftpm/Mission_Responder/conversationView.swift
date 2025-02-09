//
//  conversationView.swift
//  SSC_2025
//
//  Created by Lukas on 09.02.25.
//

import SwiftUI

struct conversationView: View {

    let conversation: Conversation = Conversation(
        initialMessage: "Hello! Please, I need help fast.",
        steps: [
            // Step 1: Ask about location (more challenging and varied)
            ConversationStep(options: [
                ResponderOption(
                    text: "Where are you right now?",
                    callerReply: "I'm at New Park Avenue 23. "
                ),
                ResponderOption(
                    text: "What is your adress?",
                    callerReply: "I live at New Park Avenue 23."
                ),
                ResponderOption(
                    text: "What happened?",
                    callerReply: "I messed up my pasta!!"
                )
            ]),
            // Step 2: Ask what happened
            ConversationStep(options: [
                ResponderOption(
                    text: "What exactly occurred?",
                    callerReply: "I was cooking and messed up the pasta—now my kitchen is burning!"
                ),
                ResponderOption(
                    text: "Can you describe the emergency?",
                    callerReply: "My kitchen caught fire when I accidentally left the pasta boiling."
                ),
                ResponderOption(
                    text: "Please explain what went wrong.",
                    callerReply: "I was preparing pasta and somehow ignited a fire in my kitchen!"
                )
            ]),
            // Step 3: Ask about people or involvement
            ConversationStep(options: [
                ResponderOption(
                    text: "Is anyone else in the house affected?",
                    callerReply: "No, it's just me here, but the fire is getting out of control."
                ),
                ResponderOption(
                    text: "Is anyone injured?",
                    callerReply: "I'm alone, thankfully, but the situation is severe."
                ),
                ResponderOption(
                    text: "Should I prepare to send multiple units?",
                    callerReply: "It's only me, but the fire is spreading quickly."
                )
            ]),
            // Step 4: Ask for severity details
            ConversationStep(options: [
                ResponderOption(
                    text: "Can you see flames or heavy smoke outside?",
                    callerReply: "Yes, there's thick smoke and large flames visible."
                ),
                ResponderOption(
                    text: "How extensive is the fire?",
                    callerReply: "The flames are rapidly spreading from the kitchen to the living area."
                ),
                ResponderOption(
                    text: "Is the fire contained or expanding?",
                    callerReply: "It's not contained; it's quickly moving beyond the kitchen."
                )
            ]),
            // Step 5: Final (lost) step with one reply option
            ConversationStep(options: [
                ResponderOption(
                    text: "Help is on the way!",
                    callerReply: "Thank you"
                )
            ])
        ]
    )

    @State private var messages: [Message] = []
    @State private var currentStep: Int = 0

    var body: some View {
        VStack (spacing: 10){
            ZStack (alignment: .bottom) {
                VStack (alignment: .leading, spacing: 10){
                  //  Text("Conversation")
                   //     .font(.system(size: 22, weight: .bold, design: .monospaced))
                    //    .padding(.bottom)
/*
                    textBubble(text: "Hello! Please, I need help fast.", isIncoming: true)
                    textBubble(text: "Where are you right now?", isIncoming: false)
                    textBubble(text: "Infront of my house. Hauptstraße 59", isIncoming: true)
                    textBubble(text: "What happened?", isIncoming: false)
                    textBubble(text: "I messed up the pasta! The kitchen is burning!!!", isIncoming: true)
*/
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack (spacing: 15){
                                ForEach(messages) { message in
                                    textBubble(text: message.text, isIncoming: message.isIncoming)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
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
                                        // Append responder's message.
                                        messages.append(Message(text: option.text, isIncoming: false))
                                        // Append caller's fixed reply.
                                        messages.append(Message(text: option.callerReply, isIncoming: true))
                                        // Advance to the next conversation step.
                                        currentStep += 1
                                    }) {
                                        answerOption(text: option.text)
                                    }
                                }
                            }
                            .padding(10)
                        }
                        .padding(.horizontal, 1)
                        .scrollIndicators(.hidden)
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




    let mediumConversation = Conversation(
        initialMessage: "Hello! Please, I need help fast.",
        steps: [
            ConversationStep(options: [
                ResponderOption(
                    text: "Where are you right now?",
                    callerReply: "I'm at Hauptstraße 59, in front of my house."
                ),
                ResponderOption(
                    text: "What's your exact location? Tell me your address.",
                    callerReply: "I'm at Hauptstraße 59, near the park."
                ),
                ResponderOption(
                    text: "Are you trying to order pizza or something?",
                    callerReply: "No, I'm not ordering pizza; I'm in trouble at Hauptstraße 59."
                )
            ]),
            ConversationStep(options: [
                ResponderOption(
                    text: "What happened?",
                    callerReply: "The kitchen caught fire because I messed up the pasta!"
                ),
                ResponderOption(
                    text: "Explain what went wrong, please.",
                    callerReply: "I was cooking pasta and accidentally set the kitchen on fire."
                ),
                ResponderOption(
                    text: "Was that pasta or a prank call?",
                    callerReply: "This is no joke—my pasta mishap led to a kitchen fire!"
                )
            ])
        ]
    )

}

// A single message bubble.
struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isIncoming: Bool
}

// Each responder option includes the text the responder sees
// and a fixed caller reply.
struct ResponderOption: Identifiable {
    let id = UUID()
    let text: String
    let callerReply: String
}

// A conversation step holds three answer options.
struct ConversationStep {
    let options: [ResponderOption]
}

// A conversation is defined by an initial caller message and a series of steps.
struct Conversation {
    let initialMessage: String
    let steps: [ConversationStep]
}
