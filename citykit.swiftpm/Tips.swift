//
//  Tips.swift
//  citykit
//
//  Created by Lukas on 26.01.25.
//
import TipKit
import SwiftUI

struct InformationTip: Tip {
  let id: String
  let titleString: String
  let messageString: String
  @Parameter static var shownTips: [String: Bool] = [:]

  var title: Text {
    Text(titleString)
  }

  var message: Text? {
    Text(messageString)
  }

  var rules: [Rule] {
    [
      #Rule(Self.$shownTips) { tip in
        tip[id] == true
      }
    ]
  }

  var options: [TipOption] {
    [
      Tip.IgnoresDisplayFrequency(true)
    ]
  }
}
