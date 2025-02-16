//
//  HapticFeedback.swift
//  SSC_2025
//
//  Created by Lukas on 16.02.25.
//
import SwiftUI

@MainActor
public func lightFeedback(){
#if os(iOS)
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
#endif
}

@MainActor
public func mediumFeedback(){
#if os(iOS)
    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
#endif
}

@MainActor
public func heavyFeedback(){
#if os(iOS)
    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
#endif
}

public func successFeedback(){
#if os(iOS)
    UINotificationFeedbackGenerator().notificationOccurred(.success)
#endif
}

@MainActor
public func softFeedback(){
#if os(iOS)
    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
#endif
}

public func errorFeedback(){
#if os(iOS)
    UINotificationFeedbackGenerator().notificationOccurred(.error)
#endif
}
