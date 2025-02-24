//
//  PlaybackRateButton.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 19.02.2025.
//

import SwiftUI

struct PlaybackRateButton: View {
    let rate: PlaybackRate
    let action: ButtonAction
    
    private let localizedTitle = String(localized: "PlaybackRate")
    
    var body: some View {
        speedButton
    }
    
    private var speedButton: some View {
        Button(action: action) {
            speedButtonLabel
        }
        .buttonStyle(.plain)
    }
    
    private var speedButtonLabel: some View {
        Text(String(format: localizedTitle, rate.rawValue.formattedString))
            .font(.footnote)
            .foregroundStyle(Color.Font.primary)
            .fontWeight(.bold)
            .padding(10)
            .background(speedButtonLabelBackground)
            .transition(.move(edge: .top))
            .animation(nil, value: UUID())
    }
    
    private var speedButtonLabelBackground: some View {
        RoundedRectangle(cornerRadius: 7)
            .fill(Color.Background.playbackRate)
    }
}
