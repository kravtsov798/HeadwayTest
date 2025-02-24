//
//  SummaryPlayer.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 17.02.2025.
//

import ComposableArchitecture
import SwiftUI

struct SummaryPlayer: View {
    var store: StoreOf<SummaryPlayerFeature>
    
    private let summaryCoverWidthDim: CGFloat = 0.55
    private let summaryCoverHeightDim : CGFloat = 1.5
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                let viewWidth = geometry.size.width
                let coverWidth = viewWidth * summaryCoverWidthDim
                let coverHeight = viewWidth * summaryCoverWidthDim * summaryCoverHeightDim
                
                summaryCover
                    .frame(width: coverWidth, height: coverHeight)
                keyPointNumber
                    .padding(.top, 40)
                keyPointTitle
                    .padding(.horizontal, 20)
                    .padding(.top, 7)
                slider
                    .padding(.horizontal, 3)
                    .padding(.vertical, 7)
                playbackRateButton
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                playerControls
                    .padding(.top, 40)
                    .padding(.bottom, 130)
            }.padding(.top, 10)
        }
    }
    
    private var summaryCover: some View {
        AsyncImage(url: store.book.coverURL) { image in
            image
                .resizable()
                .scaledToFit()
                .cornerRadius(8)
        } placeholder: {
            Skeleton(cornerRadius: 8)
        }
    }
    
    private var keyPointNumber: some View {
        Text(store.book.keyPointNumber)
            .font(.system(.footnote, weight: .bold))
            .textCase(.uppercase)
            .foregroundColor(.Font.secondary)
    }
    
    private var keyPointTitle: some View {
        Text(store.book.keyPointTitle)
            .foregroundColor(.Font.primary)
            .multilineTextAlignment(.center)
            .frame(height: 50, alignment: .top)
    }
    
    private var slider: some View {
        PlayerSlider(
            currentTime: Binding(
                get: { store.player.currentTime },
                set: { newValue in store.send(.view(.sliderMoved(newValue))) }
            ),
            duration: store.player.duration,
            startMovingAction: {
                store.send(.view(.sliderMoveInitiated))
            },
            endMovingAction: { time in
                store.send(.view(.sliderMoveFinished(time)))
            }
        )
    }
    
    private var playbackRateButton: some View {
        PlaybackRateButton(rate: store.player.playbackRate) {
            store.send(.view(.playbackRateTapped))
        }
    }
    
    private var playerControls: some View {
        HStack(spacing: 30) {
            backwardButton
            backwardFiveSecondsButton
            playButton
            forwardTenSecondsButton
            forwardButton
        }
    }
    
    private var playButton: some View {
        PlayerButton(type: store.player.isPlaying ? .pause : .play, size: 35) {
            store.send(.view(.playTapped))
        }
    }
    
    private var backwardButton: some View {
        PlayerButton(type: .backward, size: 25) {
            store.send(.view(.backwardTapped))
        }
    }
    
    private var forwardButton: some View {
        PlayerButton(type: .forward, size: 25) {
            store.send(.view(.forwardTapped))
        }
    }
    
    private var backwardFiveSecondsButton: some View {
        PlayerButton(type: .backwardFiveSeconds, size: 30) {
            store.send(.view(.backwardFiveSecondsTapped))
        }
    }
    
    private var forwardTenSecondsButton: some View {
        PlayerButton(type: .forwardTenSeconds, size: 30) {
            store.send(.view(.forwardTenSecondsTapped))
        }
    }
}

#Preview {
    SummaryPlayer(store: Store(initialState: SummaryPlayerFeature.State()) {
        SummaryPlayerFeature()
    })
}
