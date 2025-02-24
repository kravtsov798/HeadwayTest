//
//  SummaryPlayerFeature.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 17.02.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SummaryPlayerFeature {
    @Dependency(\.audioPlayer) private var player
    @Dependency(\.summaryDataSource) private var dataSource
    
    @ObservableState
    struct State {
        static let initial = Self()
        
        var book = Book()
        var view = View()
        var player = Player()
        var internalState = Internal()
        
        struct Book {
            var coverURL: URL?
            var keyPointTitle: String = ""
            var keyPointNumber: String = ""
        }
        
        struct View {
            var disableForwardButton = false
            var disableBakwardButton = false
        }
        
        struct Player {
            var isPlaying: Bool = false
            var playbackRate: PlaybackRate = .normal
            var currentTime: TimeInterval = 0
            var duration: TimeInterval = 0
        }
        
        struct Internal {
            var isCurrentTimeStreamPending = false
        }
    }
    
    enum Action {
        case view(View)
        case player(Player)
        case input(Input)
        case output(Output)
        case `internal`(Internal)
        
        enum View {
            case playTapped
            case forwardTapped
            case backwardTapped
            case forwardTenSecondsTapped
            case backwardFiveSecondsTapped
            case playbackRateTapped
            
            case sliderMoveInitiated
            case sliderMoved(TimeInterval)
            case sliderMoveFinished(TimeInterval)
        }
        
        enum Player {
            case setupPlayer
            case play
            case pause
            case setPlayTime(TimeInterval)
            case playbackFinished
            case startCurrentTimeStream
            case setupDurationStream
            case setupPlaybackFinishedStream
            case newTrackSelected
        }
        
        enum Input {
            case dataSourceUpdated
        }
        
        enum Output {
            case dataSourceUpdated
            case errorReceived(Error)
        }
        
        enum Internal {
            case updateDuration(TimeInterval)
            case updateCurrentTimeFromStream(TimeInterval)
        }
    }
    
    var body: some ReducerOf<SummaryPlayerFeature> {
        Reduce { state, action in
            switch action {
            case .view(let action):
                handle(viewAction: action, state: &state)
            case .player(let action):
                handle(playerAction: action, state: &state)
            case .input(let action):
                 handle(inputAction: action, state: &state)
            case .internal(let action):
                handle(internal: action, state: &state)
            case .output: .none
            }
        }
    }
    
    // MARK: View action handler
    private func handle(viewAction: Action.View, state: inout State) -> Effect<Action> {
        switch viewAction {
        case .playTapped:
            return .send(.player(state.player.isPlaying ? .pause : .play))
            
        case .forwardTapped:
            dataSource.moveToNext()
            return .send(.player(.newTrackSelected))
            
        case .backwardTapped:
            dataSource.moveToPrev()
            return .send(.player(.newTrackSelected))
            
        case .forwardTenSecondsTapped:
            let calculated = state.player.currentTime + 10
            let newTime = calculated <= state.player.duration ? calculated : state.player.duration
            return .send(.player(.setPlayTime(newTime)))
            
        case .backwardFiveSecondsTapped:
            let calculated = state.player.currentTime - 5
            let newTime = calculated >= 0 ? calculated : 0
            return .send(.player(.setPlayTime(newTime)))
            
        case .playbackRateTapped:
            let newRate = state.player.playbackRate.next()
            state.player.playbackRate = newRate
            player.set(rate: newRate.rawValue)
            return .none
            
        case .sliderMoveInitiated:
            state.internalState.isCurrentTimeStreamPending = true
            return .none
            
        case .sliderMoved(let newTime):
            state.player.currentTime = newTime
            return .none
            
        case .sliderMoveFinished(let newTime):
            player.set(currentTime: newTime)
            state.internalState.isCurrentTimeStreamPending = false
            return .none
        }
    }
    
    // MARK: Player action handler
    private func handle(playerAction: Action.Player, state: inout State) -> Effect<Action> {
        switch playerAction {
        case .setupPlayer:
            state.player.currentTime = 0
            
            let audioPath = dataSource.currentKeyPoint?.audioPath
            let url = URL(string: audioPath ?? "")
            
            do {
                try player.setup(with: url)
                return .run { send in
                    await send(.player(.setupDurationStream))
                    await send(.player(.setupPlaybackFinishedStream))
                }
            } catch {
                return .send(.output(.errorReceived(error)))
            }
 
        case .play:
            player.play()
            state.player.isPlaying = true
            return .run { send in
                await send(.player(.startCurrentTimeStream))
            }
            
        case .pause:
            player.pause()
            state.player.isPlaying = false
            return .none
            
        case .setPlayTime(let newTime):
            player.set(currentTime: newTime)
            return .none
            
        case .playbackFinished:
            if dataSource.isLastKeyPoint {
                return .send(.player(.pause))
            } else {
                dataSource.moveToNext()
                return .send(.player(.newTrackSelected))
            }
            
        case .startCurrentTimeStream:
            return .run { [state] send in
                for await currentTime in player.getCurrentTimeStream() {
                    if !state.internalState.isCurrentTimeStreamPending {
                        await send(.internal(.updateCurrentTimeFromStream(currentTime)))
                    }
                }
            }
            
        case .setupDurationStream:
            return .run { send in
                for await duration in player.getDurationStream() {
                    await send(.internal(.updateDuration(duration)))
                }
            }
            
        case .setupPlaybackFinishedStream:
            return .run { send in
                for await _ in player.getPlaybackFinishedStream() {
                    await send(.player(.playbackFinished))
                }
            }
            
        case .newTrackSelected:
            update(state: &state)
            return .run { [state] send in
                await send(.output(.dataSourceUpdated))
                await send(.player(.setupPlayer))
                await send(.player(state.player.isPlaying ? .play : .pause))
            }
        }
    }
    
    // MARK:  Input action handler
    private func handle(inputAction: Action.Input, state: inout State) -> Effect<Action> {
        switch inputAction {
        case .dataSourceUpdated:
            update(state: &state)
            return .run(operation: { [state] send in
                await send(.player(.setupPlayer))
                await send(.player(state.player.isPlaying ? .play : .pause))
            })
        }
    }
    
    // MARK:  Internal action handler
    private func handle(internal action: Action.Internal, state: inout State) -> Effect<Action> {
        switch action {
        case .updateDuration(let duration):
            state.player.duration = duration
            return .none
            
        case .updateCurrentTimeFromStream(let newTime):
            if !state.internalState.isCurrentTimeStreamPending {
                state.player.currentTime = newTime
            }
            return .none
        }
    }
    
    private func update(state: inout State) {
        guard let currentKeyPoint = dataSource.currentKeyPointNumber else { return }
        
        state.book.keyPointNumber = String(
            format: Localized.currentKeyPoint,
            currentKeyPoint,
            dataSource.keyPointsCount
        )
        state.book.coverURL = URL(string: dataSource.summaryCover ?? "")
        state.book.keyPointTitle = dataSource.currentKeyPoint?.title ?? ""
        
        state.view.disableForwardButton = dataSource.isFirstKeyPoint
        state.view.disableBakwardButton = dataSource.isLastKeyPoint
    }
}

extension SummaryPlayerFeature {
    enum Localized {
        static let currentKeyPoint = String(localized: "CurrentPlayItemOfTotal")
    }
}
