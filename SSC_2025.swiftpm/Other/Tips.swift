//
//  Tips.swift
//  SSC_2025
//
//  Created by Lukas on 16.02.25.
//

import SwiftUI
import TipKit

struct FireStationTip: Tip {
    var title: Text {
        Text("Fire Station")
    }


    var message: Text? {
        Text("Decide which units you needed and tap to call them")
    }


    var image: Image? {
        Image(systemName: "light.beacon.min")
    }
}
