//
//  Level1.swift
//  SSC_2025
//
//  Created by Lukas on 02.02.25.
//
import SwiftUI

struct Level1: View {
    @State var missionTitle: String = "Call emergency services"

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Mission I")
                        .font(.system(size: 25, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.red)
                    TypeWriterText($missionTitle)
                        .font(.system(size: 40, weight: .semibold, design: .monospaced))
                }
                Spacer()
            }
            .padding()

            ConversationView()

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct Level1_Previews: PreviewProvider {
    static var previews: some View {
        Level1()
    }
}
