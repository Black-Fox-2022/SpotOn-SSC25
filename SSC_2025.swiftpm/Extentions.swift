//
//  Extentions.swift
//  SSC_2025
//
//  Created by Lukas on 08.02.25.
//

import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

let orangeTint: Color = Color(hex: 0xf96407)
