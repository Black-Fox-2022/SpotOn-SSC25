//
//  Extentions.swift
//  citykit
//
//  Created by Lukas on 26.01.25.
//
import SwiftUI

extension View {
   func primaryStyle() -> some View {
       self
           .padding(.vertical, 8)
           .padding(.horizontal, 12)
           .background(
               RoundedRectangle(cornerRadius: 14)
                   .stroke(Color(.border), lineWidth: 1.0)
           )
           .foregroundColor(Color(.label))
   }
}

extension View {
    public func addBorder<S>(_ content: S = Color("BorderColor"), width: CGFloat = 1, cornerRadius: CGFloat, topLeading: CGFloat = 0, bottomLeading: CGFloat = 0, topTrailing: CGFloat = 0, bottomTrailing: CGFloat = 0, isHeavy: Bool = false, heavyColor: Color = .primary) -> some View where S : ShapeStyle {
        let roundedRect = UnevenRoundedRectangle(topLeadingRadius: cornerRadius == 0 ? topLeading : cornerRadius, bottomLeadingRadius: cornerRadius == 0 ? bottomLeading : cornerRadius, bottomTrailingRadius: cornerRadius == 0 ? bottomTrailing : cornerRadius, topTrailingRadius: cornerRadius == 0 ? topTrailing : cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(isHeavy ? heavyColor as! S : content, lineWidth: isHeavy ? width * 1.2 : width).blur(radius: 0.25))
    }
}
