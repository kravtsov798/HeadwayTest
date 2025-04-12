//
//  SummaryFeature.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 17.02.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SummaryFeature {
    @Dependency(\.summaryProvider) private var provider
    @Dependency(\.summaryDataSource) private var dataSource
    
    @ObservableState
    struct State  {
        var showToggle = true
        var showPlayer = true
        
        var showError = false
        var errorDescription = ""
        
        var player = SummaryPlayerFeature.State.initial
        var reader = SummaryReaderFeature.State.initial
    }
    
    enum Action {
        case view(View)
        case input(Input)
        case player(SummaryPlayerFeature.Action)
        case reader(SummaryReaderFeature.Action)
        
        enum View {
            case onAppear
            case toggleTapped
            case errorDismissed
        }

        enum Input {
            case showToggle
            case hideToggle
            case errorReceived(Error)
        }
    }
    
    var body: some ReducerOf<Self> {
        playerScope
        readerScope
        mainScope
    }
    
    private var playerScope: some ReducerOf<Self> {
        Scope(state: \.player, action: \.player) {
            SummaryPlayerFeature()
        }
    }
    
    private var readerScope: some ReducerOf<Self> {
        Scope(state: \.reader, action: \.reader) {
            SummaryReaderFeature()
        }
    }
    
    private var mainScope: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let action): handle(view: action, state: &state)
            case .input(let action): handle(input: action, state: &state)
            case .player(let action): handle(playerOutput: action)
            case .reader(let action):  handle(readerOutput: action)
            }
        }
    }
    
    private func handle(view action: Action.View, state: inout State) -> Effect<Action> {
        switch action {
        case .onAppear:
            return fetchSummary()
            
        case .toggleTapped:
            state.showPlayer.toggle()
            return .none
            
        case .errorDismissed:
            state.showError = false
            state.errorDescription = ""
            return .none
        }
    }
    
    private func handle(input action: Action.Input, state: inout State) -> Effect<Action> {
        switch action {
        case .errorReceived(let error):
            state.showError = true
            state.errorDescription = error.localizedDescription
            return .none
            
        case .showToggle:
            state.showToggle = true
            return .none
            
        case .hideToggle:
            state.showToggle = state.showPlayer
            return .none
        }
    }
    
    private func handle(playerOutput action: SummaryPlayerFeature.Action) -> Effect<Action> {
        switch action {
        case .output(let outputAction):
            switch outputAction {
            case .dataSourceUpdated:
                return .send(.reader(.input(.dataSourceUpdated)))
            case .errorReceived(let error):
                return .send(.input(.errorReceived(error)))
            }
        default: return .none
        }
    }
    
    private func handle(readerOutput action: SummaryReaderFeature.Action) -> Effect<Action> {
        switch action {
        case .output(let outputAction):
            switch outputAction {
            case .dataSourceUpdated:
                return .send(.player(.input(.dataSourceUpdated)))
                
            case .scrollDirectionChanged(let direction):
                return .send(.input( direction == .up ? .showToggle : .hideToggle))
            }
        default: return .none
        }
    }

    private func fetchSummary() -> Effect<Action> {
        .run { send in
            do {
                let summary = try await provider.getSummary()
                dataSource.update(summary: summary)
                
                await send(.player(.input(.dataSourceUpdated)))
                await send(.reader(.input(.dataSourceUpdated)))
            } catch {
                await send(.input(.errorReceived(error)))
            }
        }
    }
}
