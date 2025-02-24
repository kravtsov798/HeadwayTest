//
//  PlayerButtonStyle.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 18.02.2025.
//

import SwiftUI

struct PlayerButtonStyle: ButtonStyle {
    let width: CGFloat
    let height: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width, height: height)
            .animation(nil, value: UUID())
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .background {
                Circle()
                    .fill(.gray)
                    .opacity(configuration.isPressed ? 0.2 : 0)
                    .scaleEffect(configuration.isPressed ? 1.6 : 1.8)
            }
    }
}
