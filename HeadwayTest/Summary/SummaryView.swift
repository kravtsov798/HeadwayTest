//
//  ContentView.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 17.02.2025.
//

import ComposableArchitecture
import SwiftUI

struct SummaryView: View {
    public var store: StoreOf<SummaryFeature>
    
    var body: some View {
        ZStack {
            background.ignoresSafeArea()
            if store.showPlayer {
                summaryPlayer
            } else {
                summaryReader
            }
            bottomControls
                .offset(y: store.showToggle ? 0 : 100)
                .animation(.easeInOut, value: store.showToggle)
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
        .alert(isPresented: Binding(
            get: { store.showError },
            set: { _ in store.send(.view(.errorDismissed)) }
        ), content: {
            errorAlert
        })
    }
    
    private var errorAlert: Alert {
        Alert(title: Text(Localized.errorTitle ),
              message: Text(store.errorDescription))
    }
    
    private var background: some View {
        Color.Background.main
    }
    
    private var summaryPlayer: some View {
        SummaryPlayer(store: store.scope(
            state: \.player,
            action: \.player
        ))
    }
    
    private var summaryReader: some View {
        SummaryReader(store: store.scope(
            state: \.reader,
            action: \.reader
        ))
    }
    
    private var bottomControls: some View {
        VStack {
            Spacer()
            playerToReaderControl
        }
    }
    
    private var playerToReaderControl: some View {
        ZStack {
            toggle
                .onTapGesture {
                    store.send(.view(.toggleTapped), animation: .linear(duration: 0.15))
                }
            
            if !store.showPlayer {
              playButton
                    .offset(x: -90)
                    .transition(.opacity)
                    .frame(width: 55, height: 55)
            }
        }
        .animation(Animation.easeInOut(duration: 0.2), value: store.showPlayer)
    }
    
    private var toggle: some View {
        SummaryToggle(showPlayer: store.showPlayer)
    }
    
    private var playButton: some View {
        PlayerToReaderPlayButton(isPlaying: store.player.player.isPlaying) {
            store.send(.player(.view(.playTapped)))
        }
    }
}

extension SummaryView {
    enum Localized {
        static let errorTitle = String(localized: "Error")
    }
}

#Preview {
    SummaryView(store: Store(initialState: SummaryFeature.State()) {
        SummaryFeature()
    })
}
