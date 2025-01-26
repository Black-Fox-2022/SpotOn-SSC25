//
//  SwiftUIView.swift
//  citykit
//
//  Created by Lukas on 26.01.25.
//

import SwiftUI
import TipKit

struct HUDBar: View {

    @State var garbage = ""
    @State var localInformationTip = InformationTip(
        id: "",
        titleString: "",
        messageString: ""
    )


    @State private var currentDay = 1
    @State private var citizenHappiness: Int = 75
    @State private var population: Int = 10000
    @State private var notificationTitle: String = "Warning!"
    @State private var notificationMessage: String = "Test Message"

    var body: some View {
        HStack(spacing: 8) {

            Button(action: {
                garbage = UUID().uuidString

                localInformationTip = InformationTip(
                    id: garbage,
                    titleString: "Population",
                    messageString: "The number of citizens currently living in your city.")

                InformationTip.shownTips[localInformationTip.id] = true
            }, label: {
                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .font(.caption)
                            .foregroundStyle(Color(.orange))
                        Text("\(population)")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                .primaryStyle()
            })
            .popoverTip(localInformationTip)
            .id(garbage)

            Button(action: {
                garbage = UUID().uuidString

                localInformationTip = InformationTip(
                    id: garbage,
                    titleString: "Happiness",
                    messageString: "The overall happiness of the citizens in your city. If it gets too low, consider relocating to a more pleasant place.")

                InformationTip.shownTips[localInformationTip.id] = true
            }, label: {
                HStack(spacing: 4) {
                    Image(systemName: "face.smiling")
                        .font(.caption)
                        .foregroundStyle(Color(.orange))
                    Text("\(citizenHappiness)%")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .primaryStyle()
                })
            .popoverTip(localInformationTip)
            .id(garbage)

            if notificationTitle != "" {
                HStack(spacing: 4) {
                    //Image(systemName: "exclamationmark.triangle")
                    //    .frame(width: 20)
                    //Spacer()
                    Text(notificationTitle)
                    //Spacer()
                }
                .fontWeight(.medium)
                .font(.caption)
                .foregroundStyle(.yellow)

                .frame(width: 100)
                .primaryStyle()
                .padding(.horizontal, 8)
            }

            HStack(spacing: 6) {
                Button(action: {
                    currentDay -= 1
                }) {
                    Image(systemName: "chevron.backward.chevron.backward.dotted")
                        .font(.caption)
                }

                Text("Day \(currentDay)")
                    .font(.caption)
                    .fontWeight(.medium)

                Button(action: {
                    currentDay += 1
                    withAnimation(.bouncy) {
                        if notificationTitle != "" {
                            notificationTitle = ""
                        }else {
                            notificationTitle = "Warning!"
                        }
                    }
                }) {
                    Image(systemName: "chevron.right.dotted.chevron.right")
                        .font(.caption)
                        .foregroundStyle(Color(.orange))
                }
            }
            .primaryStyle()

        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                //.shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
        )
        //.frame(maxWidth: notificationTitle != "" ? 400 : 300)
    }
}

#Preview {
    HUDBar()
}
