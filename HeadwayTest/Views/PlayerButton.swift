//
//  PlayerButton.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 18.02.2025.
//

import SwiftUI

struct PlayerButton: View {
    let type: PlayerButtonType
    let size: CGFloat
    let action: ButtonAction
    
    var body: some View {
        Button(action: action, label: {
            buttonLabel
        })
        .animation(nil, value: UUID())
        .buttonStyle(PlayerButtonStyle(width: size, height: size))
    }
    
    private var buttonLabel: some View {
        Image(systemName: type.systemImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Color.Foreground.playerButton)
    }
}

extension PlayerButton {
    enum PlayerButtonType {
        case play
        case pause
        case backward
        case forward
        case forwardTenSeconds
        case backwardFiveSeconds
        
        var systemImageName: String {
            switch self {
            case .play: "play.fill"
            case .pause: "pause.fill"
            case .backward: "backward.end.fill"
            case .forward: "forward.end.fill"
            case .backwardFiveSeconds: "gobackward.5"
            case .forwardTenSeconds: "goforward.10"
            }
        }
    }
}

