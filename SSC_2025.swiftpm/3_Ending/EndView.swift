//
//  EndView.swift
//  SSC_2025
//
//  Created by Lukas on 16.02.25.
//

import SwiftUI
import AVKit

struct EndView: View {
    @Binding var currentMode: Mode

    @State private var fadeIn = false
    @State private var showSecondLine = false
    @State private var showFullQuestions = false
    @State private var showRestartBtn = false

    let link = FirefighterLink(
            country: "Germany",
            title: "#team112",
            subtitle: "Use your strenghts. Change your world!",
            url: "https://team112.bayern/",
            imageName: "Preview_GER_VF",
            countryEmoji: "🇩🇪")


    var body: some View {
        ZStack (alignment: .bottomTrailing) {
            VStack {
                Spacer()

                HStack {
                    VStack (alignment: .leading, spacing: 4){
                        TypeWriterText(.constant("Always remember!"))
                            .font(.system(size: 100, weight: .bold, design: .monospaced))
                            .foregroundStyle(orangeTint)
                        if showSecondLine {
                            VStack (alignment: .leading, spacing: 0){
                                HStack (alignment: .bottom, spacing: 0){
                                    TypeWriterText(.constant("Where"))
                                        .foregroundStyle(.primary)
                                        .font(.system(size: 80, weight: .bold, design: .monospaced))
                                    if showFullQuestions {
                                        TypeWriterText(.constant("is the emergency location?"))
                                            .foregroundStyle(.secondary)
                                            .font(.system(size: 25, weight: .medium, design: .monospaced))
                                            .padding()
                                    }
                                }
                                HStack (alignment: .bottom, spacing: 0){
                                    TypeWriterText(.constant("What"))
                                        .foregroundStyle(.primary)
                                        .font(.system(size: 80, weight: .bold, design: .monospaced))
                                    if showFullQuestions {
                                        TypeWriterText(.constant("has happened?"))
                                            .foregroundStyle(.secondary)
                                            .font(.system(size: 25, weight: .medium, design: .monospaced))
                                            .padding()
                                    }
                                }
                                HStack (alignment: .bottom, spacing: 0){
                                    TypeWriterText(.constant("Who"))
                                        .foregroundStyle(.primary)
                                        .font(.system(size: 80, weight: .bold, design: .monospaced))
                                    if showFullQuestions {
                                        TypeWriterText(.constant("is calling?"))
                                            .foregroundStyle(.secondary)
                                            .font(.system(size: 25, weight: .medium, design: .monospaced))
                                            .padding()
                                    }
                                }
                                HStack (alignment: .bottom, spacing: 0){
                                    TypeWriterText(.constant("How many"))
                                        .foregroundStyle(.primary)
                                        .font(.system(size: 80, weight: .bold, design: .monospaced))
                                    if showFullQuestions {
                                        TypeWriterText(.constant("people affected?"))
                                            .foregroundStyle(.secondary)
                                            .font(.system(size: 25, weight: .medium, design: .monospaced))
                                            .padding()
                                    }
                                }
                                HStack (alignment: .bottom, spacing: 0){
                                    TypeWriterText(.constant("Wait"))
                                        .foregroundStyle(.primary)
                                        .font(.system(size: 80, weight: .bold, design: .monospaced))
                                    if showFullQuestions {
                                        TypeWriterText(.constant("for further questions"))
                                            .foregroundStyle(.secondary)
                                            .font(.system(size: 25, weight: .medium, design: .monospaced))
                                            .padding()
                                    }
                                }
                            }
                        }

                       /* TypeWriterText(.constant("Firefighters are not just heroes."))
                            .foregroundColor(.primary)
                        if showSecondLine {
                            TypeWriterText(.constant("They are people like you!"))
                                .foregroundColor(orangeTint)
                        }
                        if showRestartBtn {
                            Button("Restart", action: {
                                withAnimation(.spring) {
                                    currentMode = .intro
                                }
                            })
                            .foregroundStyle(.secondary)
                            .font(.system(size: 16, weight: .regular, design: .monospaced))
                            .padding(.top, 4)
                        }*/
                    }
                    .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.horizontal, 50)

                Spacer()

                Text("Created with 🔥 by Lukas")
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundColor(.primary.opacity(0.6))
                    .padding(.top, 5)
                    .animation(.easeOut(duration: 1.2).delay(1.5), value: fadeIn)
                    .padding(.bottom, 30)
            }

            VStack (spacing: 0){
                Image("Sketch-BAF")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 150)
                    .offset(x: -100)
                FirefighterLinkCard(link: link)
            }
            .padding(25)
            .animation(.easeOut(duration: 1.2).delay(1.5), value: fadeIn)
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            withAnimation(.bouncy) {
                fadeIn = true
            } completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    withAnimation(.spring) {
                        showSecondLine = true
                    } completion: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 , execute: {
                            withAnimation(.bouncy) {
                                showRestartBtn = true
                                showFullQuestions = true
                            }
                        })
                    }
                })
            }
        }
    }

    private func missionSummaryBox(title: String, result: String, lesson: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 22, weight: .bold, design: .monospaced))
                .foregroundColor(.red)

            Text(result)
                .font(.system(size: 18, weight: .medium, design: .monospaced))
                .foregroundColor(.primary)

            Text(lesson)
                .font(.system(size: 16, weight: .regular, design: .monospaced))
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .frame(maxWidth: 500)
        .background(.primary.opacity(0.05))
        .clipShape(.rect(cornerRadius: 20))
        .shadow(radius: 5)
        .padding(.horizontal, 20)
    }
}

struct FirefighterLink: Identifiable {
    let id = UUID()
    let country: String
    let title: String
    let subtitle: String
    let url: String
    let imageName: String
    let countryEmoji: String
}

// 🎨 Firefighter Card View (Fully Clickable)
struct FirefighterLinkCard: View {
    let link: FirefighterLink

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                Image(link.imageName)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 250, height: 150)

                Image(systemName: "link")
                    .imageScale(.medium)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding()
            }
            .frame(width: 250, height: 150)

            VStack(alignment: .leading) {
                Text(link.title)
                    .font(.system(size: 18, weight: .semibold, design: .monospaced))
                    .foregroundColor(orangeTint)

                Text(link.subtitle)
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .frame(width: 250, height: 90, alignment: .leading)

        }
        .background(.primary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onTapGesture {
            mediumFeedback()
            if let url = URL(string: link.url) {
                UIApplication.shared.open(url)
            }
        }
    }
}

#Preview {
    EndView(currentMode: .constant(.end))
}
