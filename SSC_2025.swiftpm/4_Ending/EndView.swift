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
                    Spacer()
                    VStack (spacing: 1){
                        TypeWriterText(.constant("Firefighters are not just heroes."))
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
                        }
                    }
                    .font(.system(size: 40, weight: .bold, design: .monospaced))
                    .multilineTextAlignment(.leading)
                    Spacer()
                }

                Spacer()

                VStack(spacing: 5) {
                    Text("Thank you for playing!")
                        .font(.system(size: 22, weight: .semibold, design: .monospaced))
                        .foregroundColor(.primary.opacity(0.9))

                    HStack(spacing: 20) {
                        Text("Created with 🔥 by Lukas")
                        /*Text("🐦 Twitter")
                            .onTapGesture {
                                mediumFeedback()
                                if let url = URL(string: "https://www.twitter.com/custusfox") {
                                    UIApplication.shared.open(url)
                                }
                            }*/
                    }
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundColor(.primary.opacity(0.6))
                    .padding(.top, 5)
                }
                .animation(.easeOut(duration: 1.2).delay(1.5), value: fadeIn)
                .padding(.bottom, 30)
            }

            FirefighterLinkCard(link: link)
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
                    withAnimation(.easeInOut) {
                        showSecondLine = true
                    } completion: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 , execute: {
                            withAnimation(.bouncy) {
                                showRestartBtn = true
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


