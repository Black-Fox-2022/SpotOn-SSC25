//
//  TypingSpeed.swift
//  SSC_2025
//
//  Created by Lukas on 02.02.25.
//


import SwiftUI

struct TypeWriterText: View {

    init(_ text: Binding<String>, delay: Double = 1) {
        self._text = text
        var attributedText = AttributedString(text.wrappedValue)
        attributedText.foregroundColor = .clear
        self._attributedText = State(initialValue: attributedText)
        self._delay = State(initialValue: delay)
    }

    @Binding private var text: String
    @State private var attributedText: AttributedString
    @State private var delay: Double = 1

    var body: some View {
        Text(attributedText)
            .onAppear { animateText() }
            .onChange(of: text) { animateText() }
    }

    private func animateText(at position: Int = 0) {
        if position <= text.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05 * delay) {
                let stringStart = String(text.prefix(position))
                let stringEnd = String(text.suffix(text.count - position))
                let attributedTextStart = AttributedString(stringStart)
                var attributedTextEnd = AttributedString(stringEnd)
                attributedTextEnd.foregroundColor = .clear
                attributedText = attributedTextStart + attributedTextEnd
                animateText(at: position + 1)
            }
        } else {
            attributedText = AttributedString(text)
        }
    }

}

