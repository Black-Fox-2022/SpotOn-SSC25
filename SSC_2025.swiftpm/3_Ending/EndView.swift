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

    @State private var showLinkField = false
    @State private var showLine2 = false
    @State private var showLine3 = false
    @State private var showLine4 = false
    @State private var showLine5 = false
    @State private var showLine6 = false

    @State private var showRestartBtn = false

    let link = FirefighterLink(
            country: "Germany",
            title: "#team112",
            subtitle: "Use your strenghts. Change your world!",
            url: "https://team112.bayern/",
            imageName: "Preview_GER_VF",
            countryEmoji: "🇩🇪")


    var body: some View {
        ZStack (alignment: .bottomLeading) {
            ZStack (alignment: .bottomTrailing) {
                VStack {
                    HStack {
                        VStack (alignment: .leading, spacing: 4){
                            TypeWriterText(.constant("Always remember!"))
                                .font(.system(size: 100, weight: .bold, design: .monospaced))
                                .foregroundStyle(orangeTint)
                            VStack (alignment: .leading, spacing: 0){
                                if showLine2 {
                                    endViewLineTexts(question: "Where", fullQuestion: "is the emergency location?")
                                }
                                if showLine3 {
                                    endViewLineTexts(question: "What", fullQuestion: "has happened?")
                                }
                                if showLine4 {
                                    endViewLineTexts(question: "Who", fullQuestion: "is calling?")
                                }
                                if showLine5 {
                                    endViewLineTexts(question: "How many", fullQuestion: "people are affected?")
                                }
                                if showLine6 {
                                    endViewLineTexts(question: "Wait", fullQuestion: "for further questions")
                                }
                            }
                            Spacer()
                        }
                        .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.horizontal, 10)

                    Spacer()

                    Text("Created with 🔥 by Lukas")
                        .font(.system(size: 16, weight: .medium, design: .monospaced))
                        .foregroundColor(.primary.opacity(0.6))
                        .padding(.top, 5)
                        .opacity(showLinkField ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 1.2).delay(1.5), value: showLinkField)
                }
                .padding(30)

                VStack (spacing: 0){
                    Image("Sketch-BAF")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 150)
                        .offset(x: -100)
                    FirefighterLinkCard(link: link)
                }
                .padding(25)
                .opacity(showLinkField ? 1.0 : 0.0)
                .animation(.easeOut(duration: 1.2).delay(1.5), value: showLinkField)
            }

            Button(action: {
                withAnimation(.smooth) {
                    currentMode = .intro
                }
            }, label: {
                Image(systemName: "arrow.counterclockwise")
                    .foregroundStyle(.secondary)
            })
            .tint(.primary)
            .padding(25)
            .opacity(showLinkField ? 1.0 : 0.0)
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    withAnimation(.spring) {
                        showLine2 = true
                    } completion: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75 , execute: {
                            withAnimation(.bouncy) {
                                showLine3 = true
                            } completion: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75 , execute: {
                                    withAnimation(.bouncy) {
                                        showLine4 = true
                                    } completion: {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 , execute: {
                                            withAnimation(.bouncy) {
                                                showLine5 = true
                                            } completion: {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75 , execute: {
                                                    withAnimation(.bouncy) {
                                                        showLine6 = true
                                                    } completion: {
                                                        withAnimation(.bouncy) {
                                                            showLinkField = true
                                                        }
                                                    }
                                                })
                                            }
                                        })
                                    }
                                })
                            }
                        })
                    }
                })
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
