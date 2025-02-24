//
//  PlayerToReaderPlayButton.swift
//  HeadwayTest
//
//  Created by Andrii Kravtsov on 24.02.2025.
//

import SwiftUI

struct PlayerToReaderPlayButton: View {
    let isPlaying: Bool
    let action: ButtonAction
    
    var body: some View {
        ZStack {
            background
                .overlay { border }
            button
                .onTapGesture {
                    action()
                }
        }
        .frame(width: 55, height: 55)
    }
    
    private var background: some View {
        Color(.Background.toggle)
            .clipShape(Capsule())
    }
    
    private var border: some View {
        Capsule()
          .stroke(lineWidth: 1)
          .foregroundStyle(Color.Border.toggle)
    }
    
    private var button: some View {
        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundStyle(Color.Foreground.playerButton)
          .frame(height: 15)
    }
}
