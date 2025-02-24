//
//  PlayerSlider.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 18.02.2025.
//

import SwiftUI

struct PlayerSlider: View {
    @Binding var currentTime: TimeInterval
    let duration: TimeInterval
    let startMovingAction: ButtonAction?
    let endMovingAction: ((TimeInterval) -> Void)?
    
    var body: some View {
        HStack(spacing: 0) {
            timeText(currentTime.string)
            slider
            timeText(duration.string)
        }
        .font(.footnote)
        .foregroundColor(.gray)
        .onAppear {
            let thumbImage = UIImage(systemName: "circle.fill")
            UISlider.appearance().setThumbImage(thumbImage, for: .normal)
        }
        .onDisappear {
            UISlider.appearance().setThumbImage(nil, for: .normal)
        }
    }
    
    private func timeText(_ time: String) -> some View {
        Text(time)
            .frame(width: 60)
            .foregroundStyle(Color.Font.secondary)
    }
    
    private var slider: some View {
        Slider(value: $currentTime, in: 0...duration, onEditingChanged: { isEditing in
            isEditing ? startMovingAction?() : endMovingAction?(currentTime)
        })
        .tint(Color.Primary.blue)
    }
}
