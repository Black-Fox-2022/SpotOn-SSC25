//
//  ShakeEffect.swift
//  FireKIt
//
//  Created by Lukas on 22.02.25.
//
import SwiftUI

struct ShakeEffect: GeometryEffect {
    var travelDistance: CGFloat = 4
    var shakesPerUnit: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = travelDistance * sin(animatableData * .pi * shakesPerUnit)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}
