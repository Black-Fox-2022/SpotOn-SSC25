//
//  Message.swift
//  SSC_2025
//
//  Created by Lukas on 02.02.25.
//

import SwiftUI
import UniformTypeIdentifiers

struct Message: Identifiable {
    let id = UUID()
    var text: String
    var isUser: Bool
    var isEmpty: Bool
}

struct MessageBubbleView: View {
    @Binding var message: Message
    var onAnswer: (String) -> Void

    @State private var isDropTargeted = false

    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                userBubble
            } else {
                responderBubble
                Spacer()
            }
        }
        .padding(message.isUser ? .leading : .trailing, 60)
    }

    @ViewBuilder
    var userBubble: some View {
        if message.isEmpty {
            // Empty bubble (waiting for an answer) with a dashed border.
            Text("")
                .padding()
                .frame(minWidth: 100, maxWidth: 250, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                )
                .foregroundColor(.secondary)
                .contentShape(RoundedRectangle(cornerRadius: 16))
                .onDrop(of: [UTType.plainText.identifier],
                        isTargeted: $isDropTargeted) { providers in
                    if let provider = providers.first {
                        provider.loadObject(ofClass: String.self) { result, error in
                            if let answer = result{
                                DispatchQueue.main.async {
                                    // Animate the bubble change (resizing & content update)
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        onAnswer(answer)
                                    }
                                }
                            }
                        }
                        return true
                    }
                    return false
                }
                .transition(.scale.combined(with: .opacity))
        } else {
            // Filled bubble (with dropped answer)
            Text(message.text)
                .font(.system(size: 18, weight: .regular, design: .monospaced))
                .padding(.vertical, 12)
                .padding(.horizontal)
                .foregroundColor(.white)
                .background(Color.secondary)
                .cornerRadius(15)
                .transition(.scale.combined(with: .opacity))
        }
    }

    var responderBubble: some View {
        Text(message.text)
            .font(.system(size: 18, weight: .regular, design: .monospaced))
            .padding(.vertical, 12)
            .padding(.horizontal)
            .foregroundColor(.white)
            .background(Color.red.opacity(0.9))
            .cornerRadius(15)
            .transition(.scale.combined(with: .opacity))
    }
}

struct ConversationView: View {
    @State private var conversation: [Message] = []
    @State private var availableAnswers: [String] = ["Fire", "Robbery", "Medical", "Other"]

    var body: some View {
        HStack(alignment: .top, spacing: 50) {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach($conversation) { $message in
                        MessageBubbleView(message: $message, onAnswer: { answer in
                            if let index = conversation.firstIndex(where: { $0.id == message.id }) {
                                // Animate the transition from empty to filled bubble.
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    conversation[index].text = answer
                                    conversation[index].isEmpty = false
                                }
                                // After a short delay, add the responder’s follow-up message.
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    addResponderMessage(for: answer)
                                }
                            }
                        })
                    }
                }
                .padding()
            }
            .frame(maxWidth: 750)
            .scrollIndicators(.hidden)

            VStack(spacing: 10) {
                ForEach(availableAnswers, id: \.self) { answer in
                    Text(answer)
                        .font(.system(size: 18, weight: .regular, design: .monospaced))
                        .frame(width: 120)
                        .padding()
                        .contentShape(RoundedRectangle(cornerRadius: 15))
                        .background(Color.secondary)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .contentShape(RoundedRectangle(cornerRadius: 15))
                        .onDrag {
                            NSItemProvider(object: answer as NSString)
                        }
                }
                Spacer()
            }
            .padding()
        }
        .onAppear {
            startConversation()
        }
    }

    func startConversation() {
        // Add the initial responder message with a bouncy spring animation.
        let responderMessage = Message(text: "Hello, what's your emergency?", isUser: false, isEmpty: false)
        withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)) {
            conversation.append(responderMessage)
        }
        // Then add an empty user bubble after a delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let userMessage = Message(text: "", isUser: true, isEmpty: true)
            withAnimation(.easeInOut(duration: 0.3)) {
                conversation.append(userMessage)
            }
        }
    }

    /// Simulates the responder’s follow-up message after an answer is provided.
    func addResponderMessage(for answer: String) {
        let responderText = "You reported: \(answer). Please stay on the line."
        let responderMessage = Message(text: responderText, isUser: false, isEmpty: false)
        withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)) {
            conversation.append(responderMessage)
        }
        // Append a new empty user bubble for the next answer.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let newUserMessage = Message(text: "", isUser: true, isEmpty: true)
            withAnimation(.easeInOut(duration: 0.3)) {
                conversation.append(newUserMessage)
            }
        }
    }
}
