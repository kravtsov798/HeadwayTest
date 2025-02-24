//
//  DirectionButton.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 17.02.2025.
//

import SwiftUI

typealias ButtonAction = () -> Void

struct DirectionButton: View {
    let direction: Direction
    let size: CGFloat
    let action: ButtonAction
    
    var body: some View {
        Button(action: action) {
            buttonLabel
                .frame(width: size, height: size)
                .background(buttonLabelBackground)
        }
    }
    
    private var buttonLabel: some View {
        Image(systemName: direction.systemImageName)
            .foregroundStyle(Color.Foreground.directionButton)
            .animation(.none)
    }
    
    private var buttonLabelBackground: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.Background.directionButton)
    }
}

extension DirectionButton {
    enum Direction {
        case forward
        case backward
        
        var systemImageName: String {
            switch self {
            case .forward: "arrow.right"
            case .backward: "arrow.left"
            }
        }
    }
}

#Preview {
    DirectionButton(direction: .backward, size: 40, action: {
        print("Tapped")
    })
}
