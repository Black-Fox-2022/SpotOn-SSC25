//
//  QuestionLine.swift
//  FireKIt
//
//  Created by Lukas on 19.02.25.
//

import SwiftUI

struct endViewLineTexts: View {
    @State private var showFullQuestion: Bool = false

    let question: String
    let fullQuestion: String

    var body: some View {
        HStack (alignment: .bottom, spacing: 0){
            TypeWriterText(.constant(question))
                .foregroundStyle(.primary)
                .font(.system(size: 80, weight: .bold, design: .monospaced))
            if showFullQuestion {
                Text(fullQuestion)
                    .foregroundStyle(.secondary)
                    .font(.system(size: 25, weight: .medium, design: .monospaced))
                    .padding()
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                withAnimation(.easeIn) {
                    showFullQuestion = true
                }
            })
        }
    }
}
